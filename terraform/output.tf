output "frontend_instance_id" {
  value = module.ec2_instances.frontend_instance_id
}

output "backend_instance_id" {
  value = module.ec2_instances.backend_instance_id
}

output "jenkins_instance_id" {
  value = module.ec2_instances.jenkins_instance_id
}

output "s3_bucket_arn" {
  value = module.s3_bucket.bucket_arn
}

