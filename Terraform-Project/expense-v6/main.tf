# to display all available details of an existing security group in one output block


provider "aws" {
  region = "us-east-1" # Update this to your desired AWS region
}

# Data source to fetch the existing Security Group
data "aws_security_group" "main" {
  id = var.vpc_security_group_id
}

#output the entire data.aws_security_group.main object.
# Outputs to display Security Group details
output "security_group_id" {
  description = "The ID of the security group"
  value       = data.aws_security_group.main
}


# Outputs to display Security Group details for individual attributes
output "security_group_id" {
  description = "The ID of the security group"
  value       = data.aws_security_group.main.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = data.aws_security_group.main.name
}

output "security_group_description" {
  description = "The description of the security group"
  value       = data.aws_security_group.main.description
}

output "security_group_vpc_id" {
  description = "The VPC ID where the security group is located"
  value       = data.aws_security_group.main.vpc_id
}
