resource "aws_s3_bucket" "bucket" {
  provider = aws.aws1
  bucket = var.bucket
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  provider = aws.aws1
  bucket = aws_s3_bucket.bucket.id
  policy = templatefile("${path.module}/policies/bucket-policy.json", {
    roleArn : aws_iam_role.bucket-writer.arn,
    bucket : var.bucket
  })
}
