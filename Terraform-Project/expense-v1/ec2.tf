resource "aws_instance" "frontend" {
  ami           = "ami-0fcc78c828f981df2" # N.Virginia AMI
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-082319ecdb6b861c8"]

    tags = {
        Name = "frontend"
    }

}

resource "aws_instance" "backend" {
  ami           = "ami-0fcc78c828f981df2" # N.Virginia AMI
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-082319ecdb6b861c8"]

    tags = {
        Name = "backend"
    }

}

resource "aws_instance" "mysql" {
  ami           = "ami-0fcc78c828f981df2" # N.Virginia AMI
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-082319ecdb6b861c8"]

    tags = {
        Name = "mysql"
    }

}