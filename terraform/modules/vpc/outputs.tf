output "vpc_id" {
  value = module.myapp-vpc.vpc_id
}

output "default_route_table_id" {
  value = module.myapp-vpc.default_route_table_id
}

output "public_subnets" {
  value = module.myapp-vpc.public_subnets
}

output "private_subnets" {
  value = module.myapp-vpc.private_subnets
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.private.name
}
