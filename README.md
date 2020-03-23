# Terraform Munki Repo

`terraform-munki-repo` is a [Terraform](https://terraform.io) module that will set up a production-ready Munki repo for you. It is designed for use with Terraform 0.11.x More specifically, it will create:

* An S3 bucket to store your Munki repo
* An S3 bucket to store your logs
* A CloudFront Distribution so your clients will pull from an AWS endpoint near them
* A Lambda@Edge function that will set up basic authentication

## Why should I use this?

A Munki repo is a basic web server. But you still need to worry about setting up one or more servers, patching those servers, and scaling them around the world if you have clients in more than one country.

Amazon Web Services has crazy-high levels of uptime - more than we could ever manage ourselves. CloudFront powers some of the world's busiest websites without breaking a sweat, so it can handle your Munki repo without any trouble. It makes sense to offload the running of these services so that we can get on with our day.

### Initial Terraform / AWS Setup

1) [Register for an AWS account](https://aws.amazon.com/) if you don't have one.
2) Once you have logged in and set up billing, head over to IAM and create a user with the following permissions:
  `AWSLambdaFullAccess`,
  `IAMFullAccess`,
  `AmazonS3FullAccess`,
  `CloudFrontFullAccess`
3) Generate an access key and secret key for the user. Download the CSV (or you'll lose the secret key; it's only displayed once at initial creation).
4) Install `awscli` from https://awscli.amazonaws.com/AWSCLIV2.pkg
5) Install terraform 0.11.14 (0.12.x will print distractiing warnings) from  https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_darwin_amd64.zip (Unzip and copy the `terraform` binary to `/usr/local/bin/terraform`)
5) Run `aws configure`.
    * For "AWS Access Key ID" enter the "Access key ID" from the credentials.csv you downloaded in step 3.
    * For "AWS Secret Access Key" enter the "Secret access key" from the credentials.csv you downloaded in step 3.
    * For "Default region name" enter "us-east-1". Lambda@Edge currently requires the us-east-1 region.
    * For "Default output format" enter either "text" or "json" (or whatever you prefer)

### Terraform Usage

Create a new empty directory wherever you want to store this. Inside that directory, create a file called `main.tf`. Put the following content in it - adjust the variables to match what you want the bucket to be called (the name must be globally unique across all of Amazon), and the username and password your Munki clients will use to access the repo)

``` terraform
# change the following variables

# prefix should be globally unique. Some characters seem to cause issues;
# I'd recommend sticking with lower-case-letters and underscores
# Something like org_yourorg_munki might be a good prefix.
variable "prefix" {
  default = "you_better_change_me"
}

# you'd need to change this only if you have an existing bucket named
# "munki-s3-bucket"
variable "munki_s3_bucket" {
  default = "munki-s3-bucket"
}

# the price class for your CloudFront distribution
# one of PriceClass_All, PriceClass_200, PriceClass_100
variable "price_class" {
  default = "PriceClass_100"
}

# the username your Munki clients will use for BasicAuthentication
variable "username" {
  default = "YOU_BETTER_CHANGE_ME"
}

# the password your Munki clients will use for BasicAuthentication
variable "password" {
  default = "YOU_BETTER_CHANGE_ME"
}


# the rest should be able to be left as-is unless you are an expert

# NOTE: currently the _only_ supported provider region is us-east-1.
provider "aws" {
  region  = "us-east-1"
}

module "munki-repo" {
  source  = "grahamgilbert/munki-repo/aws"
  version = "0.1.11"
  munki_s3_bucket = "${var.munki_s3_bucket}"
  username        = "${var.username}"
  password        = "${var.password}"
  prefix          = "${var.prefix}"
  price_class = "${var.price_class}"
}

# These help you get the information you'll need to do the repo sync
# and to configure your Munki clients to use your new cloud repo

output "cloudfront_url" {
  value = "${module.munki-repo.cloudfront_url}"
}

output "munki_bucket_id" {
  value = "${module.munki-repo.munki_bucket_id}"
}

output "username" {
  value = "${var.username}"
}

output "password" {
  value = "${var.password}"
}

```

`cd` into the directory containing your `main.tf` and run the following commands:

``` bash
$ terraform init
$ terraform get
$ terraform plan
```

If everything goes well and terraform says it will create everything you expect, you can apply (type in `yes` when you are asked):

``` bash
$ terraform apply
```

Then you can get your distribution's url:

``` bash
$ terraform output cloudfront_url
```

Get the S3 bucket id:

``` bash
$ terraform output munki_bucket_id
```
(Unless you've changed it from the suggested name in the `main.tf` above, it will be "munki-s3-bucket")

Get the username and password:

``` bash
$ terraform output username
$ terraform output password
```

(Again these should match the ones you put into `main.tf`)

## Getting your Munki repo into S3

Assuming your repo is in `/Users/Shared/munki_repo` - adjust this path for your environment.

``` bash
$ aws s3 sync "/Users/Shared/munki_repo" s3://<munki_bucket_id> --exclude '*.git/*' --exclude '.DS_Store' --delete
```
(Be sure to substitute your actual munki_bucket_id for `<munki_bucket_id>` -- unless you've changed things in `main.tf` it will be "munki-s3-bucket")

Now it's just a matter of configuring your Munki clients to connect to your new repo. The [Munki wiki](https://github.com/munki/munki/wiki/Using-Basic-Authentication#configuring-the-clients-to-use-a-password) covers configuring the clients to use BasicAuthentication using the username and password you've chosen. Be sure also to set Munki's `SoftwareRepoURL` to "https://<cloudfront_url>" where you substitute the cloudfront_url you retreived earlier.
