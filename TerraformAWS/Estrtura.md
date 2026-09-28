# Arquitetura básica de um projeto Terraform
Obs: Você pode colocar tudo na main.tf.

```
terraform-ec2/
│
├── provider.tf - Configura o provider AWS.
├── main.tf - Contém os recursos.
├── variables.tf - Declara variáveis.
├── outputs.tf - Exibe informações importantes depois do terraform apply.
├── versions.tf - Define versões do Terraform e dos providers.
├── terraform.tfvars - Define valores dessas variáveis.
├── .gitignore
└── README.md
```

