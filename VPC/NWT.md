# NAT GATEWAY

**O que é ?**
É uma via de mão única, os recursos associados as suas subnets privadas associadas a um NGW só podem acessar a internet, mas a internet não pode acessar elas.

**COMO CRIAR:**

1.  Crie um Nat Gateway
   - Selecione sua subnet publica (Importante)
   - É necessário alocar um Elastic IP
2.  Crie uma tabela de roteamento e associe as subents privadas nela
3.  Faça as regras de roteamento
| Destination | Target |
| --- | --- |
| 0.0.0.0/0 | Seu Nat Gateway |

## NAT Instance 

É possível utilziar uma instancia EC2 previamente configurada com um software de NAT (Como o Nginx Proxy Manager) para realizar a função do NAT Gateway.

Este recurso é um recurso que demanda de maior complexidade de configuração e é um recurso relativamente mais barato que o NAT Gateway, porém com altas cargas, o mesmo pode não dar conta.