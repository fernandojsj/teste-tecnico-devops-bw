output "vpc_id" {
  description = "ID da VPC do ambiente"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID da subnet publica do ambiente"
  value       = module.network.public_subnet_id
}

output "ecr_repository_url" {
  description = "URL do repositorio ECR do ambiente"
  value       = module.ecr.repository_url
}
