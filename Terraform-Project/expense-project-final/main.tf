# This is  a Root Module because Main entry point; includes high-level orchestration of infrastructure

module "app" {
  for_each = var.components

  source                   = "./app"
  ami                      = data.aws_ami.main.image_id
  instance_type            = each.value["instance_type"]
  name                     = each.key
  vpc_security_group_ids   = [data.aws_security_group.main.id]
  zone_id                  = data.aws_route53_zone.main.id
  pwd                      = var.pwd
}
