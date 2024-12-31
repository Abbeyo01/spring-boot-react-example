output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id 
}

output "ec2_public_ip" {
  value = module.ec2_instance.frontend-instance.public_ip
}

output "ec2_public_ip" {
  value = module.ec2_instance.frontend-instance.id
}

output "ec2_public_ip" {
  value = module.ec2_instance.backend-instance.public_ip
}
output "ec2_public_ip" {
  value = module.ec2_instance.jenkins-instance.public_ip
}