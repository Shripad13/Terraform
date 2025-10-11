# All the datasources need to mention in data.tf file.

data "aws_route53_zone" "main" {
    name             = "devsecopswithshri.site"
    private_zone     = true
}
  

# By Below output it will show the  entire zone_info, when we tf plan 

#output "zone_info" {
#    value = data.aws_route53_zone.main_id
#}

data "aws_security_group" "main" {
  filter {
    name   = "group-name"       # As per the documentation : https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeSecurityGroups.html
    values = ["B58-SG"]         # Name of your security groups that was created by you during the start of the project
  }
}

data "aws_ami" "main" {
  most_recent = true
  name_regex  = "DevOps-LabImage-RHEL9"
  owners      = ["355449129696"]
}