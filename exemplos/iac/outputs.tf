output "vpc_id" {
  description = "ID da VPC do ambiente"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID da subnet publica do ambiente"
  value       = module.network.public_subnet_id
}
