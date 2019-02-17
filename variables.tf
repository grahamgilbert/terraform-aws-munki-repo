variable "username" {
  description = "Username clients use."
}

variable "password" {
  description = "Password clients use."
}

variable "munki_s3_bucket" {
  description = "The name of your s3 Bucket"
}

variable "prefix" {
  description = "Prefix before lambda and IAM names to ensure uniqueness in your account."
  default     = "munki"
}

variable "price_class" {
  default     = "PriceClass_100"
  description = "The price class your CloudFront Distribution should use."
}
