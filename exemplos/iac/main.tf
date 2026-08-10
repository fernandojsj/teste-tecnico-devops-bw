locals {
  name_prefix = "${var.project_name}-${var.environment}"

  tags = merge(var.common_tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  })
}

module "network" {
  source = "./modules/network"

  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  tags               = local.tags
}

module "ecr" {
  source = "./modules/ecr"

  repository_name      = local.name_prefix
  image_tag_mutability = var.image_tag_mutability
  scan_on_push         = var.scan_on_push
  encryption_type      = var.ecr_encryption_type
  max_image_count      = var.max_image_count
  force_delete         = var.ecr_force_delete
  tags                 = local.tags
}
