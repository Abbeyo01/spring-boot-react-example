resource "aws_db_instance" "rds" {
  allocated_storage      = var.allocated_storage
  instance_class         = var.instance_class
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = var.username
  password               = var.password
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.rds.name

  skip_final_snapshot = true

  tags = {
    Name        = "${var.env_prefix}-rds"
    Environment = var.env_prefix
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "${var.env_prefix}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.env_prefix}-rds-subnet-group"
    Environment = var.env_prefix
  }
}

#resource "aws_db_subnet_group" "private" {
 # name       = "private-db-subnet-group"
  #subnet_ids = module.myapp-vpc.private_subnets  # Reference the private subnets from the VPC module
  #tags = {
   # Name = "private-db-subnet-group"
  #}
#}
resource "aws_db_subnet_group" "private" {
  name       = "${var.env_prefix}-private-db-subnet-group"
  subnet_ids = module.myapp-vpc.private_subnets  # Reference the private subnets
  tags = {
    Name        = "${var.env_prefix}-private-db-subnet-group"
    Environment = var.env_prefix
  }
}
