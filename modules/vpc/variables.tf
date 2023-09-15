variable "app_name" {
  type        = string
  description = "Application name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr_block" {
  type    = string
  default = "VPC CIDR block"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones that the services are running"
}

variable "public_subnets_cidr_block" {
  type        = list(string)
  description = "Public subnets CIDR block"
}

variable "private_subnets_cidr_block" {
  type        = list(string)
  description = "Private subnets CIDR block"
}

variable "database_subnets_cidr_block" {
  type        = list(string)
  description = "Database subnets CIDR block"
}
