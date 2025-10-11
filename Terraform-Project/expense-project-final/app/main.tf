# This is a Child Module because Reusable, self-contained infrastructure units (e.g., VPC, EC2, RDS)

# Creates multiple EC2 instances

resource "aws_instance" "main" {
  ami           = var.ami 
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = var.name
  }
}

# Creates DNS Record

resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name = "${var.name}-dev.devsecopswithshri.site"
  type = "A"
  ttl = "10"
  records = [aws_instance.main.private_ip]
}



# This is dependent on ec2 instance and route53 record creation. Once both of created, then only I would like to run this.
# For this to control the order of execution we can something called as depends_on
resource "null_resource" "app" {
  depends_on = [aws_route53_record.main, aws_instance.main]

  triggers = {                      # This is to ensure that the provisioner runs every time
    always_run = true
  }
  provisioner "local-exec" {
    command = "sleep 50; cd /home/ec2-user/Ansible ; ansible-playbook -i inv-dev  -e ansible_user=ec2-user -e ansible_password=DevOps321 -e COMPONENT=${var.name} -e ENV=dev -e PWD=${var.pwd} expense.yml"
  }
}