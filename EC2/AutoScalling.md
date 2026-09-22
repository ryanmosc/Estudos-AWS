# Auto Scaling

Esta função é responsavel em criar novas instancias EC2 de forma automatica, baseada em métricas.

Exemplo:
- Você possui uma aplicação rodando em 1 EC2, durante a noite ela tem 20 usuarios, porém durante o dia 20.000 usuarios, 1 EC2 sozinha não daria conta, então ele cria de forma automatica mais EC2 ou o quanto for necessário para aguentar. E depois que sua aplicação volta para 20 usuarios ele deleta as EC2 criadas.
Scaling in - Aumenta
Scaling out - diminui

**COMO ELE CRIA?:**
A criação das EC2 são baseadas em Launch Tenplate, que são instruções de como a EC2 deve subir e como ele deve subir
Ele também precisa de 3 metricas principais, são elas:
  - **Minimum** = Minimo de EC2
  - **Desired** = Quantidade desejada
  - **Maximum** = Quantidade máxima

**Health Checks:**
- O Auto Scaling também detecta a integridade das EC2

**Integração com ELB:**
- O ALB sabe que uma nova instancia foi criada pois o Auto Scaling adiciona de forma automatica as novas EC2 no Target Group que o ALB toma conta

```markdown
```text
Internet
   │
   ▼
  ALB
   │
   ▼
Auto Scaling Group
   │
 ┌─┼──┐
 ▼ ▼  ▼
EC2 EC2 EC2
```

**Forma de Cobrança:**
- O Auto Scaling não é pago, você paga pelas EC2 utilizadas 

**IMPORTANTE:**
- A AWS chama est serviço de escalabilidade Horizontal 
- Este serviço utilzia Launch Templates, que são templates de como a aplicação deve subir. 
  DIFERENÇA DE AMI E LAUNCH TEMPLATE:
    - AMI é uma imagem de um server com coisas
    - É a instrução utilizando uma AMI de como o server deve subir
      
**OBSERVAÇÂO:**
  - Para atualizar suas inatncias dentro do AutoScalling, basta usar o Instance Refresh