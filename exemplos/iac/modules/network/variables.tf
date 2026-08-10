variable "name_prefix" {
  description = "Prefixo usado no nome dos recursos de rede, geralmente <projeto>-<ambiente>"
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
  description = "Availability zone onde a subnet publica sera criada"
  type        = string
}

variable "tags" {
  description = "Tags comuns aplicadas a todos os recursos de rede"
  type        = map(string)
  default     = {}
}
