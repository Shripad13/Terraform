resource "aws_instance" "main" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

    tags = {
        Name = "TerraformDemoInstance"
    }

}

