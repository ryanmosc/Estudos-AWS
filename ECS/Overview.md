# AWS ECS 

Elastic Container Service (ECS) é um serviço da amazon de orquestração de conatiners. Ele permite executar, escalar, monitorar e gerenciar aplicações docker de forma simples e integrada a aos serviços da AWS. É um serviço nativo e de uso exclusivo na AWS.

## Hierarquia do ECS


```
Cluster
    │
    ├── Service
    │      │
    │      ├── Task
    │      │      │
    │      │      └── Container
    │      │
    │      └── Task
    │             │
    │             └── Container
    │
    ├── Service
    │      │
    │      ├── Task
    │      │      │
    │      │      └── Container
    │      │
    │      └── Task
    │             │
    │             └── Container
```

## Arquitetura completa

```
           Internet
                      │
                  Route 53
                      │
                      ▼
                     ALB
          ┌───────────┴───────────┐
          ▼                       ▼
   Front Target Group      API Target Group
          │                       │
          ▼                       ▼
   Front Service           Backend Service
          │                       │
     Auto Scaling          Auto Scaling
          │                       │
          └─────────────┬─────────┘
                        ▼
                  ECS Cluster
                        │
                (Fargate ou EC2)
                        │
                Amazon RDS / S3
```



```
ALB DEV
Cluster: dev-cluster
 ├── Service: frontend-service
 ├── Service: backend-service
 └── Service: worker-service (se tiver)

ALB HOMOLOGAÇÂO
Cluster: hml-cluster (homologação)
 ├── Service: frontend-service
 ├── Service: backend-service
 └── Service: worker-service

ALB PROD
Cluster: prod-cluster
 ├── Service: frontend-service
 ├── Service: backend-service
 └── Service: worker-service

```


**IMPORTANTE:**
- o Target Group deve ser do tipo IP
- Deve criar um TG para o front e um TG para back e etc...
- Para cada subdominio deve haver um Listen Rule no ALB