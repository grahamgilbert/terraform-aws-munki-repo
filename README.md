# terraform-munki-repo

`terraform-munki-repo` is a [Terraform](https://terraform.io) module that will set up a production ready Munki repo for you. More specifically it will create:

* An s3 bucket to store your Munki repo
* An s3 bucket to store your logs
* A CloudFront Distribution so your clients will pull from an AWS endpoint near them
* A Lambda@Edge function that will set up basic authentication

## Why?

A Munki repo is a basic web server. But you still need to worry about setting up one or more servers, patching those servers, scaling them around the world if you have clients in more than one country.

Amazon Web Services have crazy high levels of up time - more than we could ever manage ourselves. So it makes sense to offload the running of these services so we can get on with our day.

## Usage

### Initial Terraform / AWS Setup

1) [Register for an AWS account](https://aws.amazon.com/) if you haven't already got one.
2) Once logged in and youv'e set up billing, head over to IAM and create a user with the `AdministratorAccess` permission.
3) Generate an access key and secret for the user. Download the CSV.
4) Install [homebrew](https://brew.sh)
5) `brew install awscli`
6) `brew install terraform`
7) `aws configure` and follow the prompts to log in and to set a default region (I like `us-east-1` but choose one where you are happy having your data stored)

### Using the thing

Create a file called `main.tf` wherever you want to store these things. Put the following content in it - adjust the variables to match what you want the bucket to be called (the name must be globally unique across all of Amazon), and the username and password your Munki clients will use to access the repo)

``` terraform
module "munki" {
  source          = "git::https://github.com/grahamgilbert/terraform-munki-repo.git//munki"
  munki_s3_bucket = "my-munki-bucket"
  username        = "munki"
  password        = "ilovemunki"
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
terraform state show module.munki.aws_cloudfront_distribution.www_distribution | grep domain_name
```