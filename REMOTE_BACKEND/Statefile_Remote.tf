#In this tf file, i just created a simple EC2 instance and storing its state file in the S3 bucket created previously and using dynamo db table for state locking.
terraform {
    backend "s3" {
      # Replace this with your bucket name!
      bucket         = "statefilesofharsha"
      key            = "terraform.tfstate"
      region = "us-east-2"

      # Replace this with your DynamoDB table name!
      dynamodb_table = "statefilelock"
      encrypt        = true
    }
  }


resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  

  tags = {
    Name = "harshatestec2"
  }
}
