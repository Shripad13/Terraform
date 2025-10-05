# Here commented instance_type = "t3.micro" of mysql variable component to see if terraform apply fails or not as instance_type is mandatory field.
# It will fail as instance_type is mandatory field.

# Use conditions if instance_type is not provided for any component then give default value as t2.small
# Now, will make instance_type as optional field by using condition & will give default value as t2.small if instance_type is not provided for any component.


resource "aws_instance" "main" {
  for_each = var.component
  ami = "ami-0fcc78c828f981df2" # N.Virginia AMI
  #instance_type = each.value.instance_type
  #instance_type = each.value["instance_type"] == ".*" ? each.value["instance_type"] : "t2.small"
  instance_type = each.value["instance_type"] != null ? each.value["instance_type"] : "t2.small"   # this is another way of writing above line
  vpc_security_group_ids = ["sg-082319ecdb6b861c8"]

  tags = {
    Name = each.key
    Business_Unit = each.value.business_unit
  }
}


#frontend, backend & mysql are 3 different each.key
#t3.small, t3.micro & t3.micro are 3 different each.value

variable "component" {
  default ={
    frontend = {                      #each.key
      instance_type = "t3.small"     #each.value
      business_unit = "dev"
    }
    backend = {
      instance_type = "t3.micro"
      business_unit = "dev"
    }
    mysql = {
      # instance_type = "t3.micro"
      business_unit = "DB"
    }
  }
}


# Here commented line 31 to see if terraform apply fails or not as instance_type is mandatory field.
# It will fail as instance_type is mandatory field.


#Key is frontend (which can be called by each.key) & value is { instance_type = "t3.small" business_unit = "dev" } (which can be called by each.value)
# All the values of it can be referenced by using each.value or to pick a specific value we go as shown.