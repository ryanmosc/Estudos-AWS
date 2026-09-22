# O que é ?
É uma via de mão dupla, os recursos associados a subnets públicas com um IGW, podem ser acessadas pela internet e podem acessar a internet.

**COMO CRIAR:**
1.  - Crie um Internet Gateway
2.  - Associe o Internet Gateway a sua VPC
3.  - Crie uma Route Table nova e associe ela a sua VPC.
4.  - Edit a mesma e faça a associação das subnets que serão públicas.
5.  - Faça a regra de rotas:
| Destination | Target |
| --- | --- |
| 0.0.0.0/0 | Seu internet Gateway |
|   |   |