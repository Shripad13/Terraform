

resource "aws_instance" "main" {
  count = length(var.component)
  ami = "ami-0fcc78c828f981df2" # N.Virginia AMI
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-082319ecdb6b861c8"]

  tags = {
    Name = "var.component[count.index]"
  }
}


variable "component" {
  default = ["frontend", "backend","mysql"]
  
}

# Name = "frontend-${count.index}" --> frontend-0, frontend-1, frontend-2
# Name = "frontend-${count.index + 1}" --> frontend-1, frontend-2, frontend-3
