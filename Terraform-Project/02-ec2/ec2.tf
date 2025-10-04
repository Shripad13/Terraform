resource "aws_instance" "main" {
  ami           = "ami-0fcc78c828f981df2" # N.Virginia AMI
  instance_type = "t2.micro"

    tags = {
        Name = "TerraformDemoInstance"
    }

}

