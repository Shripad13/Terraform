# Now, would like to create 3 instances with names frontend, backend, mysql with different instance_type for each instance.
# to overcome this issue will use for_each loop fucntion.

resource "aws_instance" "main" {
  for_each = var.component
  ami = "ami-0fcc78c828f981df2" # N.Virginia AMI
  instance_type = each.value.instance_type
  vpc_security_group_ids = ["sg-082319ecdb6b861c8"]

  tags = {
    Name = each.key
  }
}


#frontend, backend & mysql are 3 different each.key
#t3.small, t3.micro & t3.micro are 3 different each.value

variable "component" {
  default ={
    frontend = {                      #each.key
      instance_type = "t3.small"     #each.value
    }
    backend = {
      instance_type = "t3.micro"
    }
    mysql = {
      instance_type = "t3.micro"
    }    
  }   
}


