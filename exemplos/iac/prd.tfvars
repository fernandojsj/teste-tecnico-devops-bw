aws_region         = "us-east-1"
environment        = "prd"
project_name       = "teste-tecnico-bw"
vpc_cidr           = "10.1.0.0/16"
public_subnet_cidr = "10.1.1.0/24"
availability_zone  = "us-east-1a"

common_tags = {
  Owner = "fernando"
}

image_tag_mutability = "IMMUTABLE"
scan_on_push         = true
ecr_encryption_type  = "AES256"
max_image_count      = 20
ecr_force_delete     = false
