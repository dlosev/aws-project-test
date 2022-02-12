provider "aws" {
  region  = var.region_2
  profile = var.aws_profile_2
}

provider "aws" {
  alias = "aws1"

  region  = var.region_1
  profile = var.aws_profile_1
}

data "aws_availability_zones" "availability-zones" {
  state = "available"
}
