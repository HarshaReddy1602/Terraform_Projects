#By running the “terraform plan” or the “terrafom apply” commands, a file called terraform.
  #tfstate is created which contains a list of infrastructure resources in JSON format. 
 # In this project we are creating an S3 bucket for storing the statefiles and using dynamo table for state locking    
#create and S3 bucket with versioning enabled for it, and also enable Server-side encryption, and create one dynamodb table 
# after creating the above resources create another tf file for which you want to store the state file in the S3 bucket, (check another file in the same folder) */

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state" {

  bucket = "statefilesofharsha"
  force_destroy = true

}

# Enable versioning so you can see the full revision history of your state files

resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "statefilelock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
