variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"
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
variable "instance_class" {}
variable "my_ip" {}
variable "public_key_location" {}
variable "image_name" {}
variable "env_prefix" {}
variable subnet_cidr_block {}
variable avail_zone {}
/*variable my_ip {}*/

variable private_key_location {}
