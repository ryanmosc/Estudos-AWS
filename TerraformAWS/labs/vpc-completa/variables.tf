variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

#===============================================================================================

#Configurações da Subnet pública A
variable "cidr_public_subnet_A" {
  description = "Bloco CIDR da Subnet pública A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone_subnet_public_A" {
  description = "Zona de disponibilidade da Subnet pública A"
  type        = string
  default     = "us-east-1a"
}

#===============================================================================================

#Configurações da Subnet pública B
variable "cidr_public_subnet_B" {
  description = "Bloco CIDR da Subnet pública B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_subnet_public_B" {
  description = "Zona de disponibilidade da Subnet pública B"
  type        = string
  default     = "us-east-1c"
}

#===============================================================================================

#Configurações da Subnet privada A
variable "cidr_private_subnet_A" {
  description = "Bloco CIDR da Subnet privada A"
  type        = string
  default     = "10.0.10.0/24"
}

variable "availability_zone_subnet_private_A" {
  description = "Zona de disponibilidade da Subnet privada A"
  type        = string
  default     = "us-east-1a"
}

#===============================================================================================

#Configurações da Subnet privada B
variable "cidr_private_subnet_B" {
  description = "Bloco CIDR da Subnet privada B"
  type        = string
  default     = "10.0.20.0/24"
}

variable "availability_zone_subnet_private_B" {
  description = "Zona de disponibilidade da Subnet privada B"
  type        = string
  default     = "us-east-1c"
}

#===============================================================================================
