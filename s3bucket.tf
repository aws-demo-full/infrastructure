resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = var.frontend_bucket
  force_destroy = true
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = <<EOF
  {
    "Id": "bucket_policy_site",
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "bucket_policy_site_root",
        "Action": ["s3:ListBucket"],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.frontend_bucket}",
        "Principal": {"AWS":"${aws_cloudfront_origin_access_identity.main_cloudfront_origin_access_identity.iam_arn}"}
      },
      {
        "Sid": "bucket_policy_site_all",
        "Action": ["s3:GetObject"],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.frontend_bucket}/*",
        "Principal": {"AWS":"${aws_cloudfront_origin_access_identity.main_cloudfront_origin_access_identity.iam_arn}"}
      }
    ]
  }
  EOF
}

resource "aws_s3_bucket_website_configuration" "frontend_bucket_website_configuration" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}