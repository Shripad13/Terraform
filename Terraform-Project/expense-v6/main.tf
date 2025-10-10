
variable "vpc_security_group_ids" {
  description = "The ID of the VPC security group"
  default = ["sg-082319ecdb6b861c8"]
}


output "security_group_id" {
  value = data.aws_security_group.main.id
}