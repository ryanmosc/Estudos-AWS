

# Sync de Buckets S3

## 2.1 Como o `aws s3 sync` funciona

O `sync` compara origem e destino (por tamanho e data de modificação) e copia **apenas o que falta ou mudou**. Rodar de novo é seguro e copia só as diferenças.

Pontos importantes:

- **Usa um único conjunto de credenciais** para ler a origem e escrever no destino. Essas credenciais precisam de acesso aos dois buckets.
- Entre buckets, a cópia é feita **server-side**: os dados trafegam dentro da rede da AWS e **não passam pela máquina** que executa o comando.
- O S3 não tem pastas reais, só **prefixos**. O `sync` preserva toda a hierarquia de keys.

## 2.2 Sintaxe e opções úteis

```bash
aws s3 sync <ORIGEM> <DESTINO> [opções]
```

| Opção | Descrição |
|---|---|
| `--dryrun` | Mostra o que seria copiado, sem copiar nada. **Use sempre primeiro.** |
| `--delete` | Remove no destino o que não existe na origem (espelhamento). Use com cuidado. |
| `--exclude "padrão"` | Ignora arquivos que casam com o padrão. |
| `--include "padrão"` | Reinclui arquivos excluídos (a ordem importa). |
| `--storage-class CLASSE` | Define a classe de armazenamento no destino (`STANDARD_IA`, `GLACIER`...). |
| `--source-region` / `--region` | Necessário quando os buckets estão em regiões diferentes. |
| `--profile nome` | Usa um profile específico. |
| `--size-only` | Compara só pelo tamanho (ignora data). |
| `--exact-timestamps` | Copia se o timestamp for diferente, mesmo que o tamanho seja igual. |

---

## 2.3 Exemplo 1: Os dois buckets na MESMA conta

É o cenário mais simples. Basta que a identidade que roda o comando (usuário ou role da EC2) tenha permissão de leitura na origem e escrita no destino. **Não precisa de bucket policy.**

### Policy IAM da identidade

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LerOrigem",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-origem",
                "arn:aws:s3:::bucket-origem/*"
            ]
        },
        {
            "Sid": "EscreverDestino",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:AbortMultipartUpload",
                "s3:ListBucketMultipartUploads"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-destino",
                "arn:aws:s3:::bucket-destino/*"
            ]
        }
    ]
}
```

### Comandos

```bash
# 1) Teste (não copia nada)
aws s3 sync s3://bucket-origem s3://bucket-destino --dryrun

# 2) Execução real
aws s3 sync s3://bucket-origem s3://bucket-destino
```

Sincronizar apenas um prefixo (pasta):

```bash
aws s3 sync s3://bucket-origem/relatorios/ s3://bucket-destino/relatorios/
```

---

## 2.4 Exemplo 2: Um bucket em CADA conta (cross account)

Cenário: dados na **Conta A** (`bucket-origem`) e cópia na **Conta B** (`bucket-destino`), com o comando executado em uma EC2 da Conta B.

Como o `sync` usa uma única credencial, escolhemos **qual identidade** vai executar o comando. Há duas abordagens.

### Abordagem 1 (a que foi usada): Assumir a role da Conta A

A EC2 assume a role da Conta A (`S3CrossAccountRole`), que já enxerga a origem. Falta permitir que ela **escreva no destino**. Em S3 cross account, é preciso que **os dois lados permitam**: a policy da role (Conta A) e a bucket policy do destino (Conta B).

#### Passo 1: Conta A: policy da role `S3CrossAccountRole`

Inclua o bucket de destino no `Resource`:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-origem",
                "arn:aws:s3:::bucket-origem/*",
                "arn:aws:s3:::bucket-destino",
                "arn:aws:s3:::bucket-destino/*"
            ]
        }
    ]
}
```

#### Passo 2: Conta B: bucket policy do `bucket-destino`

Em *S3 > bucket-destino > Permissions > Bucket policy*:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSourceAccountRoleToWrite",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::111111111111:role/S3CrossAccountRole"
            },
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:AbortMultipartUpload",
                "s3:ListBucketMultipartUploads"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-destino",
                "arn:aws:s3:::bucket-destino/*"
            ]
        }
    ]
}
```

> **Importante:** uma bucket policy só pode ser salva **no próprio bucket** a que o `Resource` se refere, e na conta dona dele. Se colar a policy do `bucket-origem` dentro do `bucket-destino` (ou estiver logado na conta errada), o console retorna **`Policy has invalid resource`**.

#### Passo 3: Conta B: Object Ownership

Em *bucket-destino > Permissions > Object Ownership*, deixe **Bucket owner enforced** (padrão em buckets novos). Assim os objetos gravados pela role da Conta A passam a pertencer à Conta B, sem problemas de ACL.

#### Passo 4: Executar na EC2 (Conta B)

```bash
# Teste
aws s3 sync s3://bucket-origem s3://bucket-destino --profile s3cross --dryrun

# Execução real
aws s3 sync s3://bucket-origem s3://bucket-destino --profile s3cross
```

### Abordagem 2: Usar a role da própria EC2 (Conta B)

A EC2 usa suas credenciais normais (Conta B) e lê a origem graças a uma **bucket policy no bucket de origem**. Escreve no destino sem precisar de bucket policy, porque o destino é da mesma conta. Exige que alguém com acesso à Conta A edite a bucket policy.

#### Passo 1: Conta A: bucket policy do `bucket-origem`

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowEC2RoleReadForSync",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::222222222222:role/EC2SourceRole"
            },
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-origem",
                "arn:aws:s3:::bucket-origem/*"
            ]
        }
    ]
}
```

#### Passo 2: Conta B: policy da role `EC2SourceRole`

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LerOrigemCrossAccount",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-origem",
                "arn:aws:s3:::bucket-origem/*"
            ]
        },
        {
            "Sid": "EscreverDestino",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-destino",
                "arn:aws:s3:::bucket-destino/*"
            ]
        }
    ]
}
```

#### Passo 3: Executar (sem profile)

```bash
aws s3 sync s3://bucket-origem s3://bucket-destino --dryrun
aws s3 sync s3://bucket-origem s3://bucket-destino
```

### Qual abordagem escolher?

| Critério | Abordagem 1 (assume role) | Abordagem 2 (role da EC2) |
|---|---|---|
| Quem precisa agir na Conta A | Editar a policy da role | Editar a bucket policy do bucket |
| Quem precisa agir na Conta B | Bucket policy no destino | Policy na role da EC2 |
| Ownership dos objetos | Depende do *Object Ownership* do destino | Sempre da Conta B |
| Credenciais | Temporárias (profile) | Instance profile padrão |

---

## 2.5 Verificação pós-sync

Compare quantidade e tamanho total dos dois lados:

```bash
aws s3 ls s3://bucket-origem  --recursive --summarize --human-readable --profile s3cross | tail -2
aws s3 ls s3://bucket-destino --recursive --summarize --human-readable --profile s3cross | tail -2
```

Saída esperada (as duas linhas finais devem ser iguais nos dois buckets):

```
Total Objects: 1523
   Total Size: 4.2 GiB
```

Um `sync` com `--dryrun` logo após a cópia deve retornar vazio. Se listar algo, ainda há diferenças.

## 2.6 Dicas e pontos de atenção

- **Sempre use `--dryrun` antes.**
- **Não use `--delete` na primeira execução.** Ele apaga no destino tudo que não existir na origem.
- **Buckets grandes:** rode dentro de `tmux` ou `screen`, para que o comando não morra se a sessão SSH cair.
  ```bash
  tmux new -s sync
  aws s3 sync s3://bucket-origem s3://bucket-destino --profile s3cross
  ```
- **Sessão expira em 1 hora** ao assumir role. Para cópias longas, aumente a *Maximum session duration* da role e use `duration_seconds` no profile.
- **Performance:** aumente a concorrência da CLI:
  ```bash
  aws configure set default.s3.max_concurrent_requests 50
  aws configure set default.s3.max_queue_size 10000
  ```
- **Regiões diferentes:**
  ```bash
  aws s3 sync s3://bucket-origem s3://bucket-destino \
    --source-region us-east-1 --region sa-east-1
  ```
- **KMS:** se algum bucket usa SSE-KMS com chave própria, a identidade precisa de `kms:Decrypt` (origem) e `kms:GenerateDataKey` (destino), e a *key policy* deve permitir.
- **Pastas vazias:** objetos de 0 bytes terminados em `/` podem não ser copiados pelo `sync`.
- **Tags e ACLs** não são copiadas por padrão. Para esse caso, considere S3 Batch Operations.
- **Cópia contínua:** para replicar automaticamente novos objetos, use **S3 Replication** (exige versionamento nos dois buckets). O `sync` é para cópias pontuais ou agendadas (por exemplo, via cron).

---

# 3. Referência rápida de erros

| Erro / Sintoma | Causa provável | Solução |
|---|---|---|
| `AccessDenied` ao assumir a role | Falta a identity policy (Conta B) ou a trust policy está errada | Conferir o passo 1 e o passo 3 do tópico 1 |
| `AccessDenied` em `GetObject`/`PutObject`, mas `ls` funciona | `Resource` sem o `/*` | Incluir `bucket` **e** `bucket/*` |
| `AccessDenied` no `PutObject` do destino | Falta permissão em um dos lados | Verificar a policy da role **e** a bucket policy do destino |
| `Policy has invalid resource` | Policy salva no bucket/conta errada ou nome com caractere inválido | Salvar a bucket policy no bucket dono do ARN, logado na conta dele |
| `get-caller-identity` mostra a conta errada | Role não foi assumida | Usar `--profile` ou exportar as credenciais temporárias |
| `ExpiredToken` no meio do sync | Sessão de 1h expirou | Aumentar a duração da sessão e usar profile |
| `AccessDenied` com KMS | Falta `kms:Decrypt` / `kms:GenerateDataKey` | Ajustar a policy e a key policy |
| `AccessDenied` mesmo com tudo certo | SCP da Organization bloqueando | Verificar SCPs em AWS Organizations |
| Objetos no destino com owner da outra conta | *Object Ownership* não está em Bucket owner enforced | Ajustar no bucket de destino |

---

