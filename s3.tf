resource "aws_s3_bucket" "www" {
  bucket = "${var.prefix}-${var.munki_s3_bucket}"

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "logs/"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse_config" {
  bucket = aws_s3_bucket.www.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "private_acl" {
  bucket = aws_s3_bucket.www.id
  acl    = "private"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.www.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.www.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "www" {
  bucket = aws_s3_bucket.www.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.prefix}-${var.munki_s3_bucket}-logs"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.www.id
  acl    = "log-delivery-write"
}

resource aws_s3_bucket_lifecycle_configuration "log_bucket_lifecycle" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    id      = "log_bucket_lifecycle"
    status = "Enabled"
  
    transition {
        days          = "30"
        storage_class = "STANDARD_IA"
      }
  }
}
