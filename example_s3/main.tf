provider "aws" {
  region = "us-east-1"
}
module "aws_S3" {
    source = "../aws_S3"
    bucketname = var.bucketname
    aws_iam_policy_name = var.aws_iam_policy_name
    aws_iam_user_name = var.aws_iam_user_name
}
