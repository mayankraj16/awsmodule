resource "aws_s3_bucket" "example" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.example.id
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "example_user" {
  name = var.aws_iam_user_name
}

resource "aws_iam_policy" "example_policy" {
  name        = var.aws_iam_policy_name
  description = "Restrict access to S3 bucket /docs folder"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListObjectsInDocsFolder",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::{var.bucketname}"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:prefix": [
                        "/docs/*"
                    ]
                }
            }
        }
    ]
}
EOF

}

resource aws_iam_user_policy_attachment example_attachment{
user=aws_iam_user.example_user.name
policy_arn=aws_iam_policy.example_policy.arn

}
