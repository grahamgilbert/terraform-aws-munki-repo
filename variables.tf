variable "username" {
    description = "Username clients use."
}
variable "password" {
    description = "Password clients use."
}
variable "munki_s3_bucket" {
    description = "The name of your s3 Bucket"
}
variable "price_class" {
    default = "PriceClass_100"
    description = "The price class your CloudFront Distribution should use."
}
