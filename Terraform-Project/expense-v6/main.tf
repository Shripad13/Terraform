data "aws_security_group" "main" {
  id = var.vpc_security_group_ids
}

output "security_group_id" {
  value = data.aws_security_group.main.id
}