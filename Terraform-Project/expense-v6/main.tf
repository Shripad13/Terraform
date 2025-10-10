
data "aws_security_group" "main" {
  id = var.vpc_security_group_ids[0]
}

output "security_group_id" {
  value = data.aws_security_group.main.id
}

