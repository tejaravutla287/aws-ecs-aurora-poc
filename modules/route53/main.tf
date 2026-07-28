data "aws_route53_zone" "zone" {
  name = var.hosted_zone
}

resource "aws_route53_record" "app" {

  zone_id = data.aws_route53_zone.zone.zone_id

  name = "${var.environment}.${var.hosted_zone}"

  type = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
