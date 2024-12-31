provider "aws" {
  region = "eu-north-1"
}

# Fetch availability zones for your region
data "aws_availability_zones" "azs" {}

# VPC module from terraform-aws-modules (to create VPC, subnets, NAT Gateway)
module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name                = "myapp-vpc"
  cidr                = var.vpc_cidr_block
  private_subnets     = var.private_subnet_cidr_blocks
  public_subnets      = var.public_subnet_cidr_blocks
  azs                 = data.aws_availability_zones.azs.names
  enable_nat_gateway  = true
  single_nat_gateway  = true
  enable_dns_hostnames = true

  tags = {
    Name = "myapp-vpc"
  }
}

#resource "aws_default_route_table" "default" {
 # default_route_table_id = module.myapp-vpc.default_route_table_ids[0]
  #tags = {
   # Name = "default-route-table"
  #}
#}


# Security Group for SSH (allow your IP) and HTTP (allow public access)
resource "aws_security_group" "default_sg" {
  vpc_id = module.myapp-vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-sg"
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "${var.env_prefix}-private-db-subnet-group"
  subnet_ids = module.myapp-vpc.private_subnets  # Use module output
  tags = {
    Name        = "${var.env_prefix}-private-db-subnet-group"
    Environment = var.env_prefix
  }
}

#output "db_subnet_group_name" {
 # value = aws_db_subnet_group.private.name
#}


# Public Subnet (for public-facing resources like Load Balancer)
/*resource "aws_subnet" "public_subnet" {
  vpc_id                  = module.myapp-vpc.vpc_id
  cidr_block              = var.public_subnet_cidr_blocks[0]
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet"
  }
}

# Private Subnet (for internal resources like EC2 instances, DB)
resource "aws_subnet" "private_subnet" {
  vpc_id                  = module.myapp-vpc.vpc_id
  cidr_block              = var.private_subnet_cidr_blocks[0]
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet"
  }
}

# Optionally: Assigning a NAT Gateway for outbound traffic from private subnets
resource "aws_nat_gateway" "my_nat_gateway" {
  #allocation_id = module.myapp-vpc.nat_gateway_public_ips[0].id
  #subnet_id     = aws_subnet.public_subnet.id
  #allocation_id = aws_nat_gateway.my_nat_gateway[0].allocation_id

  #allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id


  tags = {
    Name = "MyNatGateway"
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "${var.env_prefix}-private-db-subnet-group"
  #subnet_ids = var.private_subnets  # Use the passed-in private subnets
  subnet_ids = module.vpc.private_subnets
  tags = {
    Name        = "${var.env_prefix}-private-db-subnet-group"
    Environment = var.env_prefix
  }
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.private.name
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.env_prefix}-private-subnet-${count.index}"
  }
}*/

