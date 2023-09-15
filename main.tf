provider "aws" {
  region = var.region
}

module "vpc" {
  source                      = "./modules/vpc"
  region                      = var.region
  app_name                    = var.app_name
  vpc_cidr_block              = var.vpc_cidr_block
  availability_zones          = var.availability_zones
  public_subnets_cidr_block   = var.public_subnets_cidr_block
  private_subnets_cidr_block  = var.private_subnets_cidr_block
  database_subnets_cidr_block = var.database_subnets_cidr_block
}
