variable "repository_name" {
  description = "Nome do repositorio ECR"
  type        = string
}

variable "image_tag_mutability" {
  description = "MUTABLE ou IMMUTABLE. Immutable impede sobrescrever uma tag ja publicada (ex.: o SHA do commit)"
  type        = string
}

variable "scan_on_push" {
  description = "Se true, a AWS escaneia a imagem por vulnerabilidades automaticamente a cada push"
  type        = bool
}

variable "encryption_type" {
  description = "Tipo de encriptacao do repositorio (AES256 ou KMS)"
  type        = string
}

variable "max_image_count" {
  description = "Quantidade maxima de imagens a manter no repositorio, o resto expira pela lifecycle policy"
  type        = number
}

variable "force_delete" {
  description = "Se true, permite apagar o repositorio mesmo com imagens dentro (destroy sem precisar esvaziar antes)"
  type        = bool
}

variable "tags" {
  description = "Tags comuns aplicadas ao repositorio"
  type        = map(string)
  default     = {}
}
