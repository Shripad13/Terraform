variable "component" {
  default = ["frontend", "backend","MySql"]
  
}

resource "aws_instance" "main" {
  count = length(var.component)
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  vpc_security_group_ids = [""]

  tags = {
    Name = "${var.component[count.index]}"
  }
}