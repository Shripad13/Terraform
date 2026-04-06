

resource "aws_instance" "main" {
  count                  = length(var.component)
  ami                    = "ami-0fcc78c828f981df2" # N.Virginia AMI
  instance_type          = "t3.micro"
  #instance_type = var.instance_type[count.index] # here instance type is based on the index number of the list declared in variable component.
  vpc_security_group_ids = ["sg-0166f62dc601938f1"]

  tags = {
    Name = "var.component[count.index]"
  }
}


variable "component" {
  default = ["frontend", "backend", "mysql"]

}

#variable "instance_type" {
  #default = ["t3.micro", "t3.medium", "t3.large"]
#}

# Name = "frontend-${count.index}" --> frontend-0, frontend-1, frontend-2
# Name = "frontend-${count.index + 1}" --> frontend-1, frontend-2, frontend-3


# Now, would like to create 3 instances with names frontend, backend, mysql with different instance_type for each instance.
# to overcome this issue will use for_each loop fucntion.