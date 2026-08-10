variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados"
  type        = string
}

variable "environment" {
  description = "Nome do ambiente (dev, prd)"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto, usado como prefixo dos recursos"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Bloco CIDR da subnet publica"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone da subnet publica"
  type        = string
}

variable "common_tags" {
  description = "Tags comuns aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
