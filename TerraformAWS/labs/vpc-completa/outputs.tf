output "name" {
  value = aws_vpc.documentacao_vpc.id
}

output "documentacao_subnet_publica_A" {
  value = aws_subnet.documentacao_subnet_publica_A.id
}

output "documentacao_subnet_publica_B" {
  value = aws_subnet.documentacao_subnet_publica_B.id
}

output "documentacao_subnet_privada_A" {
  value = aws_subnet.documentacao_subnet_privada_A.id
}

output "documentacao_subnet_privada_B" {
  value = aws_subnet.documentacao_subnet_privada_B.id
}

output "documentacao_eip" {
  value = aws_eip.documentacao_eip.id
}


output "documentacao_vpc" {
  value = aws_vpc.documentacao_vpc.id
}

