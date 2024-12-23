variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t3.micro"
}
variable "frontend_ami" {}
variable "backend_ami" {}
variable "jenkins_ami" {}
variable "bucket_name" {}
variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type = list(string)
}
variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type = list(string)
}
variable "instance_class" {
  description = "RDS instance class"
}
variable "my_ip" {
  description = "Your IP for SSH access"
}
variable "public_key_location" {
  description = "Location of your public SSH key"
}
variable "image_name" {}
variable "public_subnet_id" {}
variable "private_subnet_id" {}

variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable vpc_id {}
variable default_route_table_id {}
variable subnet_id {}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = "default-db-subnet-group"  # Provide a default value or leave it empty
}
