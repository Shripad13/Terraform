# This is a Root Module because values have been assigned to variables here.

variable "components" {
  default = {
    mysql = {
      instance_type = "t3.small"
    }
    backend = {
      instance_type = "t3.micro" # each.value
    }
    frontend = { # each.key
      instance_type = "t3.small"
    }
  }
}

variable "ami" {
    default = "ami-0fcc78c828f981df2" # N.Virginia AMI
}

variable "vpc_security_group_ids" {
    default = ["sg-082319ecdb6b861c8"]
}

variable "zone_id" {
    default = "Z0286229L26CBKJWO1LF" # Route53 Zone ID
}


