resource "aws_db_instance" "mydb" {
  engine             = "mysql"
  instance_class     = var.instance_class
  username           = "root"
  password           = "root"
  allocated_storage  = 20
  db_subnet_group_name = var.db_subnet_group_name
  tags = {
    Name = "SpringBootDatabase"
  }
}
