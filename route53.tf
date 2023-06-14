resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "main_route53_to_main_cloudfront" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.main_cloudfront.domain_name
    zone_id = "Z2FDTNDATAQYW2" # CloudFront ZoneID (https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html)
    evaluate_target_health = false
  }
}