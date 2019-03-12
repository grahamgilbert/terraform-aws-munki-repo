# Terraform Munki Repo

`terraform-munki-repo` is a [Terraform](https://terraform.io) module that will set up a production-ready Munki repo for you. More specifically, it will create:

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
4) Install [homebrew](https://brew.sh)
5) Run `brew install awscli`
6) Run `brew install terraform`
7) Run `aws configure` and follow the prompts to log in and to set a default region (I like `us-east-1` but choose one where you are happy having your data stored)

### Terraform Usage

Create a file called `main.tf` wherever you want to store these things. Put the following content in it - adjust the variables to match what you want the bucket to be called (the name must be globally unique across all of Amazon), and the username and password your Munki clients will use to access the repo)

``` terraform
module "munki-repo" {
  source  = "grahamgilbert/munki-repo/aws"
  version = "0.0.5"
  munki_s3_bucket = "my-munki-bucket"
  username        = "munki"
  password        = "ilovemunki"
  prefix          = "some_prefix_to_make_this_unique"
  # price_class is one of PriceClass_All, PriceClass_200, PriceClass_100
  price_class = "PriceClass_100"
}
```

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
$ terraform state show module.munki.aws_cloudfront_distribution.www_distribution | grep domain_name
```

## Getting your Munki repo into S3

Assuming your repo is in `/Users/Shared/munki_repo` - adjust this path for your environment.

``` bash
$ aws s3 sync "/Users/Shared/munki_repo" s3://my-bucket-name --exclude '*.git/*' --exclude '.DS_Store' --delete
```

Now it's just a matter of configuring your Munki clients to connect to your new repo. The [Munki wiki](https://github.com/munki/munki/wiki/Using-Basic-Authentication#configuring-the-clients-to-use-a-password) has you covered there.
