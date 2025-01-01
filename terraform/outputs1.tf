output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id 
}

output "frontend_ec2_public_ip" {
  value = module.ec2_instance.frontend-instance.public_ip
}

output "frontend_ec2_id" {
  value = module.ec2_instance.frontend-instance.id
}

output "backend_ec2_public_ip" {
  value = module.ec2_instance.backend-instance.public_ip
}

output "jenkins_ec2_public_ip" {
  value = module.ec2_instance.jenkins-instance.public_ip
}
