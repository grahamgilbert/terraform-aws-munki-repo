module "munki" {
  source          = "git::https://github.com/grahamgilbert/terraform-munki-repo.git//munki"
  munki_s3_bucket = "my-munki-bucket"
  username        = "munki"
  password        = "ilovemunki"
  # price_class is one of PriceClass_All, PriceClass_200, PriceClass_100
  price_class = "PriceClass_100"
}
