# Terraform AWS

O Terraform é uma ferramenta de Infrastructure as Code (IaC).

Em vez de entrar no console da AWS e criar:

```
VPC → Subnet → Security Group → EC2 → IAM Role...
```

você descreve a infraestrutura em arquivos .tf:

```
resource "aws_instance" "app" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}
```

E o Terraform transforma essa configuração em recursos reais na AWS.

**Isso traz algumas vantagens importantes:**
- Automação
- Reprodutibilidade
- Versionamento
- Padronização
- Menos configuração manual
- Facilidade para recriar ambientes
- Infraestrutura documentada como código

## Configuração inicial 
- Inicialmente você deve configurar a AWS CLI em seu terminal.