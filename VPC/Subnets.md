# Subnets
Subredes / subnets são divisões dentro de sua VPC. Supomos que você setou o bloco CIDR 10.0.0.0/16, voce possui milhares de IPS disponiveis, o ideal seria fazer uma divisão deles e distribuir entre responsabilidades.
**Obs:** Uma VPC pode ter até 200 subnets, com o tamanho máximo do bloco CIDR sendo de /16.

**EXEMPLO:**

VPC (10.0.0.0/16)
│
├── Subnet Pública
│      10.0.1.0/24
│
├── Subnet Pública
│      10.0.2.0/24
│
├── Subnet Privada
│      10.0.3.0/24
│
└── Subnet Privada
       10.0.4.0/24
       
Desta forma, cada subnet recebe uma parte dos Ips.

**SUBNET PÚBLICA:**
- Uma subnet é publica pois possui uma rota que sai para internet através de um internet getway.
  
**IMPORTANTE:**
- Uma subnet não é publica porque tem ips públicos e sim porque possui uma rota na tabela de roteamentos que leva a internet, e com isso os recursos dentro desta subnet podem ser acessados pela internet (Desde que o Security Group e regras permitam).
  
**O que fica dentro de uma subnet pública?** - Normalmente ficam recursos que precisam ser acessados da Internet, como:
- Application Load Balancer (ALB)
- Bastion Host (quando utilizado)
- NAT Gateway

**SUBNET PRIVADA:**
- É uma subnet que não tem acesso direto a internet de forma direta e com isso ninguém da internet pode acessa-lá.
  
**O que fica dentro de uma subnet privada?**
- EC2 da aplicação
- Amazon RDS
- ElastiCache
- EKS Workers

**IMPORTANTE:**

A AWS subtrai 5 IPs do total (/24 tem 256 IPs, mas apenas 251 utilizáveis).

| Numero IP | Motivo |
| --- | --- |
| 0 e 255 | Endereço de Rede (Network Address). O 255 é brodcast |
| 1 | Reservado pela AWS para o roteador da VPC (VPC Router). |
| 2 | Reservado pela AWS para o servidor DNS (Amazon Provided DNS / Route 53). |
| 3 | Reservado pela AWS para uso futuro. |

**OBSERVACAO:**

Isso é uma subrede:
Bloco CIDR: 10.0.0.0/16
subrede: **10.0.10.0/16**

Isso não é uma subrede, é host:
Bloco CIDR: 10.0.0.0/16
subrede: **10.0.0.10/16**

| Bloco            | Quantidade de IPs | Uso comum                    |
| ---------------- | ----------------: | ---------------------------- |
| `10.0.0.0/8`     |        16.777.216 | Grandes empresas, AWS, Azure |
| `172.16.0.0/12`  |         1.048.576 | Redes corporativas           |
| `192.168.0.0/16` |            65.536 | Casas e pequenos escritórios |


| CIDR | Total de IPs | Utilizáveis na AWS |
| ---- | -----------: | -----------------: |
| /16  |       65.536 |             65.531 |
| /20  |        4.096 |              4.091 |
| /24  |          256 |                251 |
| /25  |          128 |                123 |
| /26  |           64 |                 59 |
| /27  |           32 |                 27 |
| /28  |           16 |                 11 |

A máscara da subnet deve ser maior (mais específica) do que a máscara da VPC



