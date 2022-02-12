terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
  backend "s3" {
    bucket = "tf-state-dmitrylosev"
    key    = "aws-project-test.tfstate"
    region = "us-east-1"
  }
}
