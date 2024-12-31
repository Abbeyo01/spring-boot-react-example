output "frontend-instance" {
  value = aws_instance.frontend
}
output "backend-instance" {
  value = aws_instance.backend
}
output "jenkins-instance" {
  value = aws_instance.jenkins
}