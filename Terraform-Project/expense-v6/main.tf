provider "aws" {
  region = "us-east-1" # Update this to your desired AWS region
}

# Data source to fetch the existing Security Group
data "aws_security_group" "main" {
  id = var.vpc_security_group_id
}

# Outputs to display Security Group details
output "security_group_id" {
  description = "The ID of the security group"
  value       = data.aws_security_group.main
}
