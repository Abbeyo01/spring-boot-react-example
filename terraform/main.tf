provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source                  = "./../modules/vpc"
  vpc_cidr_block          = var.vpc_cidr_block
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
}

module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "s3_bucket" {
  source                   = "./../modules/s3_bucket"
  bucket_name              = var.bucket_name
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

module "ec2_instances" {
  source = "./modules/ec2_instances"
  frontend_ami = var.frontend_ami
  backend_ami = var.backend_ami
  jenkins_ami = var.jenkins_ami
  instance_type = var.instance_type
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
}

module "rds" {
  source                 = "./../modules/rds"
  instance_class         = var.instance_class
  db_subnet_group_name   = module.vpc.private_subnet_group_name
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  allocated_storage      = var.allocated_storage
  multi_az               = var.multi_az
  storage_type           = var.storage_type

  # Add missing output references
  db_instance_id         = module.rds.db_instance_id
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
  alarm_name                = "frontend-cpu-utilization-high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "Alarm if CPU utilization of the frontend instance exceeds 80%"
  dimensions = {
    InstanceId = module.ec2_instances.frontend_instance_id
  }
  actions_enabled           = true
}

# CloudWatch Alarm for Backend EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "backend_cpu_utilization" {
  alarm_name                = "backend-cpu-utilization-high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "Alarm if CPU utilization of the backend instance exceeds 80%"
  dimensions = {
    InstanceId = module.ec2_instances.backend_instance_id
  }
  actions_enabled           = true
}

# CloudWatch Alarm for Jenkins EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "jenkins_cpu_utilization" {
  alarm_name                = "jenkins-cpu-utilization-high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "Alarm if CPU utilization of the Jenkins instance exceeds 80%"
  dimensions = {
    InstanceId = module.ec2_instances.jenkins_instance_id
  }
  actions_enabled           = true
}

# CloudWatch Alarm for RDS CPU Utilization
resource "aws_cloudwatch_metric_alarm" "rds_cpu_utilization" {
  alarm_name                = "rds-cpu-utilization-high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "Alarm if RDS CPU utilization exceeds 80%"
  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }
  actions_enabled           = true
}

# CloudWatch Log Subscription for Frontend Instance Logs
resource "aws_cloudwatch_log_subscription_filter" "frontend_log_subscription" {
  name            = "frontend-log-subscription"
  log_group_name  = aws_cloudwatch_log_group.frontend_log_group.name
  filter_pattern  = ""
  destination_arn = "arn:aws:sns:us-west-2:123456789012:MyTopic"  # Example SNS topic ARN for notifications
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
