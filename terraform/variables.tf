variable "aws_profile_1" {
  type        = string
  description = "AWS profile to access account 1"
  default     = "aws-profile-1"
}

variable "aws_profile_2" {
  type        = string
  description = "AWS profile to access account 2"
  default     = "aws-profile-2"
}

variable "region_1" {
  type        = string
  description = "The region in AWS account 1 to use"
  default     = "us-east-1"
}

variable "region_2" {
  type        = string
  description = "The region in AWS account 2 to use"
  default     = "us-east-1"
}

variable "bucket" {
  type        = string
  description = "The bucket name"
  default     = "aws-project-test-dmitriy-losev"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The public subnet CIDR"
  default     = "10.0.1.0/26"
}

variable "private_subnet_cidr" {
  type        = string
  description = "The private subnet CIDR"
  default     = "10.0.1.64/26"
}

variable "ami_description" {
  type = string
  description = "AMI's description to retrieve the one to use for EC2 instance"
  default = "Amazon Linux 2 Kernel 5.10"
}
