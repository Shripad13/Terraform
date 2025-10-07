# All the datasources need to mention in data.tf file.

data "aws_route53_zone" "main" {
    name             = "devsecopswithshri.site"
    private_zone     = true
}
  

# By Below output it will show the  entire zone_info, when we tf plan 

#output "zone_info" {
#    value = data.aws_route53_zone.main_id
#}
