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

variable "image_tag_mutability" {
  description = "MUTABLE ou IMMUTABLE pro repositorio ECR"
  type        = string
}

variable "scan_on_push" {
  description = "Se true, a AWS escaneia a imagem por vulnerabilidades a cada push no ECR"
  type        = bool
}

variable "ecr_encryption_type" {
  description = "Tipo de encriptacao do repositorio ECR (AES256 ou KMS)"
  type        = string
}

variable "max_image_count" {
  description = "Quantidade maxima de imagens mantidas no ECR antes de expirar as mais antigas"
  type        = number
}

variable "ecr_force_delete" {
  description = "Se true, permite apagar o repositorio ECR mesmo com imagens dentro"
  type        = bool
}
