/*provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "myapp-vpc"
  }
}

//resource "aws_vpc" "myapp-vpc" {
//cidr_block = var.vpc_cidr_block
//tags = { 
//Name = "${var.env_prefix}-vpc"
//}
//}


module "vpc" {
  source                     = "./modules/vpc"
  vpc_cidr_block             = var.vpc_cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  my_ip                      = var.my_ip
  vpc_id                     = module.vpc.vpc_id
  frontend_ami               = var.frontend_ami
  backend_ami                = var.backend_ami
  jenkins_ami                = var.jenkins_ami
  instance_type              = var.instance_type
  image_name                 = var.image_name
  bucket_name                = var.bucket_name
  instance_class             = var.instance_class
  subnet_cidr_block          = var.subnet_cidr_block
  public_key_location        = var.public_key_location
  avail_zone                 = var.avail_zone
  env_prefix                 = var.env_prefix
  private_key_location       = var.private_key_location
}

module "myapp-subnet" {
  source                 = "./modules/subnet"
  subnet_cidr_block      = var.subnet_cidr_block
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
  vpc_id                 = module.vpc.vpc_id
  default_route_table_id = module.vpc.default_route_table_id
  #vpc_id = aws_vpc.myapp-vpc.id
  #default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "s3_bucket" {
  source                     = "./modules/s3_bucket"
  bucket_name                = var.bucket_name
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks

  frontend_ami      = var.frontend_ami
  backend_ami       = var.backend_ami
  jenkins_ami       = var.jenkins_ami
  instance_type     = var.instance_type
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  image_name        = var.image_name
  vpc_id            = module.vpc.vpc_id
  #private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  my_ip                     = var.my_ip
  #bucket_name                = var.bucket_name
  instance_class         = var.instance_class
  subnet_cidr_block      = var.subnet_cidr_block
  subnet_id              = module.myapp-subnet
  public_key_location    = var.public_key_location
  vpc_cidr_block         = var.vpc_cidr_block
  default_route_table_id = module.vpc.default_route_table_id
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
}

module "ec2_instance" {
  source                     = "./modules/ec2_instance"
  frontend_ami               = var.frontend_ami
  backend_ami                = var.backend_ami
  jenkins_ami                = var.jenkins_ami
  instance_type              = var.instance_type
  public_subnet_id           = module.vpc.public_subnet_id
  private_subnet_id          = module.vpc.private_subnet_id
  image_name                 = var.image_name
  vpc_id                     = module.vpc.vpc_id
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  my_ip                      = var.my_ip
  bucket_name                = var.bucket_name
  instance_class             = var.instance_class
  subnet_cidr_block          = var.subnet_cidr_block
  subnet_id                  = module.myapp-subnet
  public_key_location        = var.public_key_location
  vpc_cidr_block             = var.vpc_cidr_block
  default_route_table_id     = module.vpc.default_route_table_id
}

module "rds" {
  source               = "./modules/rds"
  instance_class       = var.instance_class
  db_subnet_group_name = module.vpc.private_subnet_group_name

  frontend_ami               = var.frontend_ami
  backend_ami                = var.backend_ami
  jenkins_ami                = var.jenkins_ami
  instance_type              = var.instance_type
  public_subnet_id           = module.vpc.public_subnet_id
  private_subnet_id          = module.vpc.private_subnet_id
  image_name                 = var.image_name
  vpc_id                     = module.vpc.vpc_id
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  my_ip                      = var.my_ip
  bucket_name                = var.bucket_name
  subnet_cidr_block          = var.subnet_cidr_block
  subnet_id                  = module.myapp-subnet
  public_key_location        = var.public_key_location
  vpc_cidr_block             = var.vpc_cidr_block
  default_route_table_id     = module.vpc.default_route_table_id
  avail_zone                 = var.avail_zone
  env_prefix                 = var.env_prefix
}

##########################
# CloudWatch Monitoring   #
##########################

# CloudWatch Log Group for Frontend EC2
resource "aws_cloudwatch_log_group" "frontend_log_group" {
  name = "/aws/ec2/frontend/logs"
}

# CloudWatch Log Group for Backend EC2
resource "aws_cloudwatch_log_group" "backend_log_group" {
  name = "/aws/ec2/backend/logs"
}

# CloudWatch Log Group for Jenkins EC2
resource "aws_cloudwatch_log_group" "jenkins_log_group" {
  name = "/aws/ec2/jenkins/logs"
}

# CloudWatch Log Group for RDS
resource "aws_cloudwatch_log_group" "rds_log_group" {
  name = "/aws/rds/logs"
}

# CloudWatch Alarm for Frontend EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "frontend_cpu_utilization" {
  alarm_name          = "frontend-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm if CPU utilization of the frontend instance exceeds 80%"
  dimensions = {
    InstanceId = module.ec2_instance.frontend_instance_id
  }
  actions_enabled = true
}

# CloudWatch Alarm for Backend EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "backend_cpu_utilization" {
  alarm_name          = "backend-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm if CPU utilization of the backend instance exceeds 80%"
  dimensions = {
    InstanceId = module.ec2_instance.backend_instance_id
  }
  actions_enabled = true
}

# CloudWatch Alarm for Jenkins EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "jenkins_cpu_utilization" {
  alarm_name          = "jenkins-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm if CPU utilization of the Jenkins instance exceeds 80%"
  dimensions = {
    InstanceId = module.ec2_instance.jenkins_instance_id
  }
  actions_enabled = true
}

# CloudWatch Alarm for RDS CPU Utilization
resource "aws_cloudwatch_metric_alarm" "rds_cpu_utilization" {
  alarm_name          = "rds-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm if RDS CPU utilization exceeds 80%"
  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }
  actions_enabled = true
}

# CloudWatch Log Subscription for Frontend Instance Logs
resource "aws_cloudwatch_log_subscription_filter" "frontend_log_subscription" {
  name            = "frontend-log-subscription"
  log_group_name  = aws_cloudwatch_log_group.frontend_log_group.name
  filter_pattern  = ""
  destination_arn = "arn:aws:sns:us-west-2:123456789012:MyTopic" # Example SNS topic ARN for notifications
}

# CloudWatch Log Subscription for Backend Instance Logs
resource "aws_cloudwatch_log_subscription_filter" "backend_log_subscription" {
  name            = "backend-log-subscription"
  log_group_name  = aws_cloudwatch_log_group.backend_log_group.name
  filter_pattern  = ""
  destination_arn = "arn:aws:sns:us-west-2:123456789012:MyTopic"
}

# CloudWatch Log Subscription for Jenkins Instance Logs
resource "aws_cloudwatch_log_subscription_filter" "jenkins_log_subscription" {
  name            = "jenkins-log-subscription"
  log_group_name  = aws_cloudwatch_log_group.jenkins_log_group.name
  filter_pattern  = ""
  destination_arn = "arn:aws:sns:us-west-2:123456789012:MyTopic"
}

# CloudWatch Log Subscription for RDS Logs
resource "aws_cloudwatch_log_subscription_filter" "rds_log_subscription" {
  name            = "rds-log-subscription"
  log_group_name  = aws_cloudwatch_log_group.rds_log_group.name
  filter_pattern  = ""
  destination_arn = "arn:aws:sns:us-west-2:123456789012:MyTopic"
}
res
////////////////////////////////////////////////////////////

provider "aws" {
  region = "eu-north-1"

}

data "aws_availability_zones" "azs" {
  state = "available"
}



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



module "vpc" {
  source                     = "./modules/vpc"
  vpc_cidr_block             = var.vpc_cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  env_prefix                 = var.env_prefix
  my_ip                      = var.my_ip
  #vpc_id                     = module.vpc.vpc_id
  #frontend_ami               = var.frontend_ami
  #backend_ami                = var.backend_ami
  #jenkins_ami                = var.jenkins_ami
  #instance_type              = var.instance_type
  #image_name                 = var.image_name
  #bucket_name                = var.bucket_name
  #instance_class             = var.instance_class
  #subnet_cidr_block          = var.subnet_cidr_block
  #public_key_location        = var.public_key_location
  #avail_zone                 = var.avail_zone
  #private_key_location       = var.private_key_location
  azs = data.aws_availability_zones.azs
  
}

module "myapp-subnet" {
  source                 = "./modules/subnet"
  subnet_cidr_block      = var.subnet_cidr_block
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
  vpc_id                 = module.vpc.vpc_id
  default_route_table_id = module.vpc.default_route_table_id
  #vpc_id = aws_vpc.myapp-vpc.id
  #default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id


}


module "ec2_instance" {
  source            = "./modules/ec2_instance"
  frontend_ami      = var.frontend_ami
  backend_ami       = var.backend_ami
  jenkins_ami       = var.jenkins_ami
  instance_type     = var.instance_type
  #public_subnet_id  = module.vpc.public_subnet_ids[0]
  public_subnet_id  = module.vpc.public_subnets[0].id
  private_subnet_id = module.vpc.private_subnets[0].id
  #private_subnet_id = module.vpc.private_subnet_ids[0]


  image_name                 = var.image_name
  vpc_id                     = module.vpc.vpc_id
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  my_ip                      = var.my_ip
  bucket_name                = var.bucket_name
  instance_class             = var.instance_class
  subnet_cidr_block          = var.subnet_cidr_block
  #subnet_id                  = module.myapp-subnet
  public_key_location        = var.public_key_location
  vpc_cidr_block             = var.vpc_cidr_block
  default_route_table_id     = module.vpc.default_route_table_id

  vpc_security_group_id = module.vpc.default_security_group_id
  subnet_id = module.myapp-vpc.public_subnets[0]

  #subnet_id             = module.myapp-subnet.public_subnet_ids[0]
}

module "s3_bucket" {
  source                     = "./modules/s3_bucket"
  bucket_name                = var.bucket_name
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks

  frontend_ami      = var.frontend_ami
  backend_ami       = var.backend_ami
  jenkins_ami       = var.jenkins_ami
  instance_type     = var.instance_type
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  image_name        = var.image_name
  vpc_id            = module.vpc.vpc_id
  #private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  my_ip                     = var.my_ip
  #bucket_name                = var.bucket_name
  instance_class         = var.instance_class
  subnet_cidr_block      = var.subnet_cidr_block
  subnet_id              = module.myapp-subnet
  public_key_location    = var.public_key_location
  vpc_cidr_block         = var.vpc_cidr_block
  default_route_table_id = module.vpc.default_route_table_id
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
}


module "rds" {
  source                 = "./modules/rds"
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  subnet_ids             = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.vpc.vpc_default_sg_id]

  #instance_class       = var.instance_class
  #db_subnet_group_name = module.vpc.private_subnet_group_name
  #db_subnet_group_name = aws_db_subnet_group.private.name
  db_subnet_group_name  = module.rds.db_subnet_group_name


  frontend_ami               = var.frontend_ami
  backend_ami                = var.backend_ami
  jenkins_ami                = var.jenkins_ami
  instance_type              = var.instance_type
  public_subnet_id           = module.vpc.public_subnet_id
  private_subnet_id          = module.vpc.private_subnet_id
  private_subnets  = module.myapp-vpc.private_subnets
  image_name                 = var.image_name
  vpc_id                     = module.vpc.vpc_id
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  my_ip                      = var.my_ip
  bucket_name                = var.bucket_name
  subnet_cidr_block          = var.subnet_cidr_block
  subnet_id                  = module.myapp-subnet
  public_key_location        = var.public_key_location
  vpc_cidr_block             = var.vpc_cidr_block
  default_route_table_id     = module.vpc.default_route_table_id
  avail_zone                 = var.avail_zone
  env_prefix                 = var.env_prefix
}

module "cloudwatch" {
  source     = "./modules/cloudwatch"
  env_prefix = var.env_prefix
  monitored_instance_ids = [
    module.ec2_instance.frontend_instance_id,
    module.ec2_instance.backend_instance_id,
    module.ec2_instance.jenkins_instance_id
  ]
}*/

