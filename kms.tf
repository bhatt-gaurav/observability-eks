data "aws_caller_identity" "current" {}

resource "aws_kms_key" "kms_key" {
    description = "KMS key for secret encryption"
    deletion_window_in_days = 7
    enable_key_rotation = true
    policy = <<POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
    {
        "Sid" : "Enable IAM user permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
    }
    ]

    }
  POLICY
}