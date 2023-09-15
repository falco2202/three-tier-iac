region                      = "ap-southeast-1"
app_name                    = "my-app"
vpc_cidr_block              = "10.0.0.0/16"
availability_zones          = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnets_cidr_block   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr_block  = ["10.0.3.0/24", "10.0.4.0/24"]
database_subnets_cidr_block = ["10.0.5.0/24", "10.0.6.0/24"]

