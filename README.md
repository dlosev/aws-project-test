<!--
  Title: AWS S3 Bucket Cross-Account Access Terraform example
  Description: Provisions AWS infrastructure with Terraform to demonstrate: S3 cross-account access, AWS Systems Manager Session Manager SSH access to an EC2 instance, deployed to a private network with no inbound rules declared in its security group  
  Author: Dmitry Losev
  -->

# AWS S3 Bucket Cross-Account Access example

The repository contains [Terraform](https://www.terraform.io) configuration files for provisioning AWS infrastructure
to implement S3 bucket cross-account access. [Terraform AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
is utilized to provision AWS resources.

# Table of contents

* [Architecture](#architecture)
* [Installation](#installation)
* [Usage](#usage)
  * [EC2 Instance SSH-access](#ec2-instance-ssh-access)
  * [S3 Bucket access](#s3-bucket-access)
* [Uninstallation](#uninstallation)

## Architecture

There is an AWS account where a private S3 bucket is created. There is a bucket policy defined, allowing accessing the
bucket to a role, located in the second AWS account. There is an EC2 instance in the second AWS account. The instance has
an instance profile assigned, which the role is attached to. The instance is located in a private subnet and uses a NAT
Gateway to access AWS S3 and SSM services by public URLs. There is an SSM-agent running on the instance, which registers
it with AWS System Manager.

Described architecture is shown on the [diagram](diagram.pdf). 

## Installation

1. Change working directory to [terraform](terraform) and install the required Terraform providers:
    ```bash
    cd terraform
    terraform init
    ```
2. Make sure that your local `default` AWS profile has permissions to read/write the S3 bucket to store the
[Terraform's state](https://www.terraform.io/language/settings/backends/s3). Change the [bucket name](terraform/versions.tf)
to match the one from your AWS account;
3. Make sure there are two AWS profiles, corresponding two different AWS accounts, declared in local `~/.aws/credentials`
file. Adjust profile [variables](terraform/variables.tf) to match your existing AWS profiles:\
    `aws_profile_1` - an AWS account where S3 bucket will be created;\
    `aws_profile_2` - an AWS account to access the S3 bucket from.
4. Adjust infrastructure configuration, changing [variables](terraform/variables.tf) values (if the default values don't suit);
5. Run the following command to provision the AWS resources:
    ```bash
    terraform apply
    ```

### Requirements

* [Terraform](https://www.terraform.io) v1.0.11+
* [AWS CLI](https://aws.amazon.com/cli/) 2.4.15+

## Usage

### EC2 Instance SSH-access

The EC2 instance created in private subnet and its security group doesn't have any inbound rules. So, all the ports are
closed for incoming connections. SSH access can be setup with `AWS Systems Manager -> Session Manager`. Just start a new
session and choose the instance as a target.

### S3 Bucket access

Connect to the instance with SSH and use AWS CLI to access the bucket. The following actions are permitted to execute on
the bucket by the [security policy](terraform/policies/bucket-access-policy.json) :
* List files;
* Download a file;
* Upload a file;
* Remove a file.

Here is some examples of the useful commands:
* List all the files within the bucket:
    ```bash
    aws s3 ls s3://<bucket>
    ```
    where:\
    `<bucket>` - the name of the bucket
* Upload `simple-text.txt` file to the bucket and grant the bucket's owner full control over the file:
    ```bash
    aws s3 cp simple-text.txt s3://<bucket>  --acl bucket-owner-full-control
    ```
    where:\
     `<bucket>` - the name of the bucket

## Uninstallation

1. Change working directory to [terraform](terraform) and remove all the resources Terraform created:
    ```bash
    cd terraform
    terraform destroy
    ```
   If the bucket, Terraform previously created, isn't empty, you will get the corresponding error. Terraform is not
going to remove a non-empty bucket. Just empty the bucket manually in AWS Console or with AWS CLI command first, and
then run the destroy command again.  
