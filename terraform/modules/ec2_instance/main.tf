/*resource "aws_instance" "frontend" {
  ami             = var.frontend_ami
  instance_type   = var.instance_type
  subnet_id       = var.public_subnet_id
  security_groups = [var.vpc_security_group_id]
  #security_groups = [module.vpc.default_security_group_id]
  #security_groups = [module.vpc.aws_default_security_group.default-sg]

  user_data = <<-EOF
    #!/bin/bash
    cd /var/www/html
    git clone https://github.com/Abbeyo01/spring-boot-react-example.git
    cd frontend
    npm install
    npm run build
  EOF

  tags = {
    Name = "SpringBootFrontendInstance"
  }
}

resource "aws_instance" "backend" {
  ami             = var.backend_ami
  instance_type   = var.instance_type
  subnet_id       = var.private_subnet_id
  security_groups = [var.vpc_security_group_id]
  #security_groups = [module.vpc.default_security_group_id]
  #security_groups = [aws_default_security_group.default-sg]

  user_data = <<-EOF
    #!/bin/bash
    cd /var/www/backend
    git clone https://github.com/Abbeyo01/spring-boot-react-example.git
    cd backend
    npm install
    npm start
  EOF

  tags = {
    Name = "SpringBootBackendInstance"
  }
}

resource "aws_instance" "jenkins" {
  ami             = var.jenkins_ami
  instance_type   = var.instance_type
  subnet_id       = var.public_subnet_id
  security_groups = [var.vpc_security_group_id]
  #security_groups = [module.vpc.default_security_group_id]
  #security_groups = [aws_default_security_group.default-sg]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y openjdk-11-jdk
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt update
    sudo apt install -y jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
  EOF

  tags = {
    Name = "SpringBootJenkinsInstance"
  }
}

/*resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = "${file(var.public_key_location)}"
}


output "frontend_instance_id" {
  value = aws_instance.frontend.id
}

output "backend_instance_id" {
  value = aws_instance.backend.id
}

output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}*/

