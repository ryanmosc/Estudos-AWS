# Amazon S3
Este serviço é o storage da AWS (Serviço de armazenamento de objetos).

Diferente do EBS (HD / SSD) ele armazena objetos que são compostos por:
- Arquivo
- Chave(é o identificador ex: https://my-bucket.s3.regiao.amazon_aws/images/foto)
- Metadados

**TIPOS:**
- Uso geral
- Diretorios - Recomendado quando você quer algo super rápido
- Tabela - Foi criado para armazenar dados tabularios (Colunas e linhas) como exemplo (Excel, SQL e etc...)
- Vetores - Bom para IA, é utilizado para consulta e armazenamento de vetores e indices.

**Observação:**
- Você pode acessar o objeto tanto pela chave ou por um dominio (ex: cdn.empresa.com -> https://my-bucket.s3.regiao.amazon-aws)

**Onde e para que utilizar:**
- Upload de fotos
- Videos
- Curriculos
- Arquivos
- Backups
- Logs
- Site estatico


**ATENÇÂO:**
- Após criar um bucket, não se pode mais alterar o nome e a região

```
IDEIA DE ARQUITETURA 

                    Internet
                        │
                     Route 53
                        │
                        ▼
                       ALB
                        │
                        ▼
                   Auto Scaling
                        │
        ┌───────────────┴───────────────┐
        ▼                               ▼
   EC2 App A                      EC2 App B
        │                               │
        └───────────────┬───────────────┘
                        │
            ┌───────────┴───────────┐
            ▼                       ▼
          RDS                   Bucket S3
                           (Fotos, PDFs, Vídeos)
```

