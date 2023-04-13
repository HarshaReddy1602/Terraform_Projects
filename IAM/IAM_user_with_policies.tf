provider "aws" {
  region = "us-east-2"
}
resource "aws_iam_user" "harsha" {
  count = "${length(var.username)}"
  name  = "${element(var.username, count.index)}"
}
resource "aws_iam_user_policy" "policy" {
  count  = length(var.username)
  name   = "user_policy"
  user   = element(var.username,count.index)

policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
	
	lifecyle{
	create_before_destroy = true
	}	


  ]
}
EOT
}
