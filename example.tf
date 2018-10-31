module "munki" {
  source          = "git::https://github.com/grahamgilbert/terraform-munki-repo.git//munki"
  munki_s3_bucket = "my-munki-bucket"
  username        = "munki"
  password        = "ilovemunki"
}
