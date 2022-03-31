data "aws_route53_zone" "saturn" {
  name  = "${var.root_domain}."
}

resource "aws_route53_record" "demo" {
  zone_id = data.aws_route53_zone.saturn.zone_id
  name    = "demo.${var.root_domain}"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3.domain_name
    zone_id                = aws_cloudfront_distribution.s3.hosted_zone_id
    evaluate_target_health = true
  }
}
