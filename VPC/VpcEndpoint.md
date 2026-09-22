# VPC Endpoint

Este recurso permite a comunicação entre serviços (Suportados) AWS de forma privada, através de uma tecnologia denominada de Private Link.

- O trafego entre serviços da AWS que utilizarem o VPC Endpoint ficam em uma rede privada da AWS
- Instancias do VPC endpoint, não precisam de um endereço IP público para prover a comunicação
- Possuimos dois tipos de VPC endpoints:
    - Interface Endpoints: É o conjunto de ENI que utiliza um AWS private link para prover a comunicação.
    - Gateway endpoints: Especifica endereços IP em uma tabela de roteamento (prefix lists) para direcionar o tráfego para o destino (DynamoDB ou Amazon S3)

**COMO FAZER UM ENDPOINT PARA ACESSAR INSTANCIAS PRIVADAS:**

1 - Criar o endpoint 
-  Selecionar o tipo de serviço
-  Selecionar a VPC
- Selecionar as subnets (Mesma subnet que as instancias estão)
2 - Modificar a subnet
    - Deve modificar a subnet em que você atrelou os serviços e o endpoint
    - Deve adicionar uma regra de entrada e de saída (Ambas iguais)
      

| TYPE | SOURCE |
| --- | --- |
| SSH | securitygroup_que_o_endpoint_esta |
