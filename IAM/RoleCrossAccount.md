# Acesso Cross Account

> Documentação prática baseada em um caso real: uma EC2 em uma conta precisa acessar e clonar um bucket S3 que está em outra conta.

---

# 1. Cross Account com Assume Role

## 1.1 O que é

**Assume Role** é o mecanismo do IAM que permite a uma identidade (usuário ou role) **assumir temporariamente** as permissões de uma role. Quando a role está em **outra conta AWS**, chamamos isso de acesso **cross account**.

Em vez de criar usuários e chaves de acesso fixas na outra conta, a identidade chama o **STS** (`sts:AssumeRole`) e recebe **credenciais temporárias** (`AccessKeyId`, `SecretAccessKey`, `SessionToken`) com as permissões da role assumida.

**Vantagens**

- Sem chaves de acesso permanentes, que eliminam o risco de vazamento.
- Credenciais expiram automaticamente (padrão de 1 hora).
- Controle centralizado: a conta dona do recurso decide quem entra.
- Auditoria no CloudTrail mostrando quem assumiu o quê.

## 1.2 Como funciona

```
 CONTA B (222222222222)                         CONTA A (111111111111)
┌──────────────────────────┐                   ┌────────────────────────────┐
│  EC2                     │                   │  Role: S3CrossAccountRole  │
│   └─ Role: EC2SourceRole │                   │                            │
│        │                 │   1. AssumeRole   │  Trust policy:             │
│        │  Identity policy│ ────────────────► │   "EC2SourceRole pode      │
│        │  permite         │                  │    me assumir"             │
│        │  sts:AssumeRole  │ ◄──────────────── │                            │
│        │                 │  2. Credenciais   │  Permissions policy:       │
│        │                 │     temporárias   │   "pode acessar o S3"      │
│        ▼                 │                   │                            │
│   3. Usa as credenciais  │ ────────────────► │  Bucket S3 (bucket-origem) │
└──────────────────────────┘                   └────────────────────────────┘
```

## 1.3 As 3 políticas envolvidas

Em cross account, **os dois lados precisam permitir**. Se qualquer uma faltar, o acesso é negado.

| # | Política | Onde fica | Função |
|---|---|---|---|
| 1 | **Trust policy** (relação de confiança) | Role da Conta A (destino do assume) | Define **quem pode assumir** a role |
| 2 | **Permissions policy** | Role da Conta A | Define **o que a role pode fazer** depois de assumida |
| 3 | **Identity policy** | Role/usuário da Conta B (quem assume) | Autoriza a identidade a **chamar** `sts:AssumeRole` naquela role |

## 1.4 Passo a passo

### Passo 1: Criar a role na Conta A (a que será assumida)

**Console:** IAM > Roles > Create role > **AWS account** > *Another AWS account* > informe o ID da Conta B.

Depois ajuste a **Trust policy** para restringir à role específica, em vez da conta inteira:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::222222222222:role/EC2SourceRole"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
```

> **Boa prática:** use o ARN da role em `Principal`, e não `arn:aws:iam::222222222222:root`. Com `root`, qualquer identidade da Conta B que tiver a permissão `sts:AssumeRole` poderia assumir a role.

### Passo 2: Anexar a Permissions policy na role da Conta A

Defina o que a role pode fazer. Exemplo com acesso total a um bucket:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::bucket-origem",
                "arn:aws:s3:::bucket-origem/*"
            ]
        }
    ]
}
```

> **Atenção ao `Resource`:** o ARN `arn:aws:s3:::bucket` representa **somente o bucket** (ações como `ListBucket`). O ARN `arn:aws:s3:::bucket/*` representa **os objetos** (ações como `GetObject`, `PutObject`, `DeleteObject`). Você precisa dos dois.

### Passo 3: Autorizar a Conta B a chamar AssumeRole

Na role da EC2 (`EC2SourceRole`, Conta B), anexe esta policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::111111111111:role/S3CrossAccountRole"
        }
    ]
}
```

### Passo 4: Assumir a role

**Opção A: Comando direto**

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::111111111111:role/S3CrossAccountRole \
  --role-session-name minha-sessao
```

A resposta traz o bloco `Credentials`. Exporte as variáveis:

```bash
CREDS=$(aws sts assume-role \
  --role-arn arn:aws:iam::111111111111:role/S3CrossAccountRole \
  --role-session-name minha-sessao \
  --query 'Credentials' --output json)

export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .SessionToken)
```

Para voltar às credenciais originais da EC2:

```bash
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
```

**Opção B: Profile (recomendado)**

A CLI renova as credenciais sozinha. Edite `~/.aws/config`:

```ini
[profile s3cross]
role_arn = arn:aws:iam::111111111111:role/S3CrossAccountRole
credential_source = Ec2InstanceMetadata
```

Uso:

```bash
aws s3 ls s3://bucket-origem --profile s3cross
```

> `credential_source = Ec2InstanceMetadata` faz a CLI usar a instance role da EC2 como ponto de partida. Fora de uma EC2, use `source_profile = nome-do-profile-base`.

### Passo 5: Validar

```bash
aws sts get-caller-identity --profile s3cross
```

Resultado esperado:

```json
{
    "UserId": "AROAXXXXXXXXXXXX:minha-sessao",
    "Account": "111111111111",
    "Arn": "arn:aws:sts::111111111111:assumed-role/S3CrossAccountRole/minha-sessao"
}
```

Se `Account` mostrar a Conta B (`222222222222`), a role **não** foi assumida.

## 1.5 Boas práticas

- **Menor privilégio:** prefira ações específicas (`s3:GetObject`, `s3:ListBucket`) em vez de `s3:*` quando possível.
- **Trust policy restrita:** aponte para a role específica, não para `root`.
- **ExternalId:** em cenários com terceiros, exija um `sts:ExternalId` na trust policy para evitar o problema do *confused deputy*:
  ```json
  "Condition": { "StringEquals": { "sts:ExternalId": "valor-secreto" } }
  ```
- **Duração da sessão:** o padrão é 1 hora. Pode ser aumentada na role (*Maximum session duration*, até 12h). No profile: `duration_seconds = 7200`.
- **Role chaining:** quando uma role assume outra role, a sessão é limitada a **1 hora**, independentemente da configuração.
- **SCPs:** em AWS Organizations, verifique se alguma SCP bloqueia `sts:AssumeRole` ou as ações de S3.
- **Auditoria:** acompanhe os eventos `AssumeRole` no CloudTrail.

---

