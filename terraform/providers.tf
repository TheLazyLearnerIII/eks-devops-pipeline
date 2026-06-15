terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.48.0"
    }
  }
}
provider "aws" {
    region = "us-east-1"
}