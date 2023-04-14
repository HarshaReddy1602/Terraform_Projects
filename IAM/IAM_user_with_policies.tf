/*Hello All, There are multiple ways to create IAM users and attach policies using terraform. 
		In this terraform project we are creating IAM USERS AND Attaching policies to the users, you can give any number of users you want to create in the variable file.


IAM POLICIES, helps the user to access the AWS resources and for AWS it requires standard JSON format for creating policies.
		
You can specify each user different policy based on the user name in the aws_iam_user_policy resource 
	*/


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

  ]
}
EOT
}
