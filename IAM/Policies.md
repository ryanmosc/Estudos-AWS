## IAMPolicies
As **políticas do IAM (*IAM Policies*)** são a espinha dorsal de toda a segurança e controle de acesso na AWS. Elas são documentos formais em formato **JSON** que definem explicitamente **quem** pode fazer **o quê**, em **qual recurso** e sob **quais condições**.

Sem uma política associada (seja diretamente a um usuário, a um grupo ou a uma *Role*), nenhuma ação pode ser executada na conta. Por padrão, a AWS adota uma postura de **Negação Implícita (*Implicit Deny*)**: tudo é proibido até que uma política explicitamente autorize.

---

### 1. A Estrutura de uma Política em JSON

Uma política do IAM é composta por blocos de declaração (*Statements*). Cada instrução possui uma estrutura padrão:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PermitirAcessoS3Dev",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::meu-bucket-de-dev/*"
    }
  ]
}

```

* **Version:** A versão da linguagem da política (o padrão recomendado pela AWS é `"2012-10-17"`).
* **Effect:** Define a ação principal: **`Allow`** (Permitir) ou **`Deny`** (Negar).
* **Action:** A lista de operações específicas de serviços permitidas ou negadas (ex: `ec2:StartInstances`, `s3:GetObject`).
* **Resource:** O recurso exato da AWS que será afetado, identificado por seu **ARN** (*Amazon Resource Name*). Usar `*` indica todos os recursos do tipo.
* **Condition (Opcional):** Regras de restrição adicionais, como exigir MFA, restringir por faixa de IP ou horários (ex: permitir acesso apenas se a requisição vier do IP do escritório).

---

### 2. A Regra de Ouro: `Allow` vs `Deny` (E a Negação Explícita)

Entender o fluxo de avaliação de uma política é fundamental para evitar brechas de segurança:

1. **Implicit Deny (Padrão):** Se não houver uma instrução `Allow` expressa, o acesso é negado.
2. **Explicit Allow:** Se houver uma instrução `Allow`, o acesso é concedido.
3. **Explicit Deny (A Regra Suprema):** Se houver uma única instrução **`Deny`** afetando o recurso ou ação, **ela sempre sobressai a qualquer `Allow**`, não importa onde esteja configurada.

> **Exemplo:** Se o Grupo `Devs` tem permissão de `Allow`  total no Amazon S3, mas você anexa uma política de `Deny` (DescribleBuckets )no S3 diretamente para o usuário *Pedro*, o `Deny` ganha e Pedro será bloqueado. Ou seja ele ainda tem a permissão total no S3 mas a função especifica que foi bloqueada, ele perde o acesso. 

---

### 3. Os Tipos de Políticas do IAM

A AWS divide as políticas em três categorias principais:

* **AWS Managed Policies (Gerenciadas pela AWS):** Criadas e mantidas pela própria AWS. São prontas para uso (ex: `AdministratorAccess`, `AmazonS3ReadOnlyAccess`). São ótimas para começar, mas podem conceder permissões em excesso.
* **Customer Managed Policies (Gerenciadas pelo Cliente):** Criadas e personalizadas por você. Permitem aplicar com precisão o **Princípio do Menor Privilégio**, concedendo acesso apenas ao que é estritamente necessário.
* **Inline Policies (Políticas Embutidas):** Políticas criadas e vinculadas exclusivamente a uma única identidade (usuário, grupo ou *role*). Se a identidade for excluída, a política é destruída junto. *(Uso recomendado apenas para exceções específicas)*.

---

### 4. Categorias de Políticas quanto à Atribuição

* **Identity-based Policies (Baseadas em Identidade):** Anexadas a Usuários, Grupos ou *Roles*. Definem o que aquela identidade pode fazer na conta.
* **Resource-based Policies (Baseadas em Recurso):** Anexadas diretamente ao recurso da AWS (como uma Bucket Policy do Amazon S3 ou uma fila do SQS). Definem **quem** tem permissão para acessar aquele recurso específico.

---

Aqui está a reescrita do seu texto, corrigindo os desvios gramaticais, melhorando a clareza e ajustando a terminologia técnica:

---

## Resumo

> * **Grupos e Políticas:** Os grupos de usuários contêm políticas (*policies*) de acesso.
> * **Propósito dos Grupos:** Eles foram criados para agrupar múltiplas políticas, facilitando a atribuição e a gestão de permissões para os usuários em escala.
> * **Herança e Permissões Individuais:** Os usuários adicionados a um grupo herdam todas as suas políticas automaticamente. No entanto, eles também podem possuir políticas específicas e exclusivas anexadas diretamente às suas contas.
> * **Prioridade do Deny (Exemplo Prático):** Se o grupo `Devs` possui acesso total ao serviço (`Allow: ec2:*`), mas o usuário **Ryan** possui uma política individual de negação (`Deny: ec2:DescribeInstances`), a instrução de **Deny** prevalece. Na avaliação de políticas da AWS, a negação explícita sempre tem prioridade sobre a permissão.



- Os grupos tem policies (Politicas)
  
- Os grupos são criados para agrupar varias policies e faciliar na hora de adicionar politicas a usuarios
  
- Os usuarios dentro do grupo herdam as policies do grupo mas podem ter policies especificar e unicas como ex: O grupo dev tem acesso full a EC2 porém o usuario Ryan dentro do grupo tem um Deny sobre Describeinstances. Ou seja o Deny vem na frente.  



```mermaid
graph TD
    subgraph "Grupo: Devs"
        P_Grupo["Política do Grupo:<br>• Allow: ec2:* (Acesso Full ao EC2)"]
        
        subgraph "Usuário: Ryan (Membro do Grupo)"
            P_User["Política Individual (Inline/Direct):<br>• Deny: ec2:DescribeInstances"]
        end
    end

    P_Grupo -->|Herda Permissões| U_Resultado
    P_User -->|Aplica Restrição Direta| U_Resultado

    subgraph "Resultado Efetivo para o Usuário Ryan"
        U_Resultado["
        Pode criar/deletar/iniciar instâncias (ec2:*)
        NÃO pode listar/descrever instâncias (ec2:DescribeInstances)
        
        Motivo: O Deny explícito SOBRESAI ao Allow!
        "]
    end

    classDef grupo fill:#232f3e,stroke:#ff9900,stroke-width:2px,color:#fff;
    classDef politica fill:#e6f2ff,stroke:#0066cc,stroke-width:1px,color:#000;
    classDef resultado fill:#fff0f0,stroke:#cc0000,stroke-width:2px,color:#000;

    class P_Grupo grupo;
    class P_User politica;

    class U_Resultado resultado;

    