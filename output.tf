output "munki_bucket_id" {
  value = "${aws_s3_bucket.www.id}"
}

output "log_bucket_id" {
  value = "${aws_s3_bucket.log_bucket.id}"
}

output "cloudfront_id" {
  value = "${aws_cloudfront_distribution.www_distribution.id}"
}

output "cloudfront_url" {
  value = "${aws_cloudfront_distribution.www_distribution.domain_name}"
}
