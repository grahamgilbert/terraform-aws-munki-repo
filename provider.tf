terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.59"
    }
  }
}

provider "aws" {
  alias   = "use1"
  region  = "us-east-1"
}
