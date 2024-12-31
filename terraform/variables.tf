variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "env_prefix" {
  description = "Prefix for resources"
  default     = "dev"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t3.micro"
}

variable "frontend_ami" {
  description = "AMI for frontend EC2 instances"
}

variable "backend_ami" {
  description = "AMI for backend EC2 instances"
}

variable "jenkins_ami" {
  description = "AMI for Jenkins EC2 instance"
}

variable "bucket_name" {
  description = "S3 bucket name"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  default     = 20
}

variable "rds_db_name" {
  description = "RDS database name"
}

variable "rds_username" {
  description = "RDS database username"
}

variable "rds_password" {
  description = "RDS database password"
}

variable "my_ip" {
  description = "Your IP address for security"
}

variable "public_key_location" {
  description = "Path to your SSH public key"
}

variable "instance_class" {
  description = "Class of the instance"
}

variable "image_name" {
  description = "AMI image name"
}

variable "avail_zone" {
  description = "Availability zone"
}

variable "private_key_location" {
  description = "Path to your private SSH key"
}

variable "subnet_cidr_block" {
  description = "Subnet CIDR block"
}
