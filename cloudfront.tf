resource "aws_cloudfront_distribution" "www_distribution" {
  origin {
    // Here we're using our S3 bucket's URL!
    domain_name = "${aws_s3_bucket.www.bucket_regional_domain_name}"

    // This can be any name to identify this origin.
    origin_id = "munki"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  default_root_object = "index.html"
  price_class         = "${var.price_class}"

  // All values are defaults from the AWS console.
  default_cache_behavior {
    lambda_function_association {
      event_type = "viewer-request"
      lambda_arn = "${aws_lambda_function.basic_auth_lambda.arn}:${aws_lambda_function.basic_auth_lambda.version}"
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    // This needs to match the `origin_id` above.
    target_origin_id = "munki"
    min_ttl          = 0
    default_ttl      = 86400
    max_ttl          = 31536000

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern = "/catalogs/*"

    lambda_function_association {
      event_type = "viewer-request"
      lambda_arn = "${aws_lambda_function.basic_auth_lambda.arn}:${aws_lambda_function.basic_auth_lambda.version}"
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    min_ttl                = 0
    default_ttl            = 30
    max_ttl                = 60
    target_origin_id       = "munki"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern = "/manifests/*"
    min_ttl      = 0
    default_ttl  = 30
    max_ttl      = 60

    lambda_function_association {
      event_type = "viewer-request"
      lambda_arn = "${aws_lambda_function.basic_auth_lambda.arn}:${aws_lambda_function.basic_auth_lambda.version}"
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "munki"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Some comment"
}
