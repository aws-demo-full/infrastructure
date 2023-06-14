resource "aws_acm_certificate" "cloudfront_cert" {
  provider = aws.us-east-1
  domain_name       = var.domain
  subject_alternative_names = ["www.${var.domain}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cloudfront_cert_validation" {
  name = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.main.zone_id
  records = [tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_value]
  ttl = 60
}

resource "aws_route53_record" "www_cloudfront_cert_validation" {
  name = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[1].resource_record_name
  type = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[1].resource_record_type
  zone_id = aws_route53_zone.main.zone_id
  records = [tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[1].resource_record_value]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  provider = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [aws_route53_record.cloudfront_cert_validation.fqdn, aws_route53_record.www_cloudfront_cert_validation.fqdn]
}