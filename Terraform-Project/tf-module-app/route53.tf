resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = "${var.name}-${var.env}.devsecopswithshri.site"
  type    = "A"
  ttl     = 10
  records = [aws_instance.main.private_ip]
}