# Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "nat_gateway" {
  value = module.vpc.nat_gateway
}

output "nat_eip" {
  value = module.vpc.nat_eip
}

