data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "bucket-writer" {
  assume_role_policy  = templatefile("${path.module}/policies/assume-role-policy.json", {
    service : "ec2"
  })
  managed_policy_arns = [data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn]
}

resource "aws_iam_role_policy" "bucket-writer-policy" {
  policy   = templatefile("${path.module}/policies/bucket-access-policy.json", {
    bucket : var.bucket
  })
  role     = aws_iam_role.bucket-writer.id
}

resource "aws_iam_instance_profile" "test-instance-profile" {
  name = "test-instance-profile"
  role = aws_iam_role.bucket-writer.name
}
