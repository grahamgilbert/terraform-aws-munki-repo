resource "aws_s3_bucket" "www" {
  bucket = "${var.prefix}-${var.munki_s3_bucket}"

  logging {
    target_bucket = "${aws_s3_bucket.log_bucket.id}"
    target_prefix = "logs/"
  }

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.www.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.www.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "www" {
  bucket = "${aws_s3_bucket.www.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.prefix}-${var.munki_s3_bucket}-logs"
  acl    = "log-delivery-write"

  lifecycle_rule {
    enabled = true

    transition {
      days          = "30"
      storage_class = "STANDARD_IA"
    }
  }
}
