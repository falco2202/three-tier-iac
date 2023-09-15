output "vpc_id" {
  value = aws_vpc.three_tier_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "database_subnets" {
  value = aws_subnet.database_subnets.*.id
}

output "nat_gateway" {
  value = aws_nat_gateway.nat_gateway.id
}

output "nat_eip" {
  value = aws_eip.nat_eip.public_ip
}
