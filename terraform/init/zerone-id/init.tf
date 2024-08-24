provider "aws" {
  region = "ap-northeast-2"
  assume_role {
    role_arn     = var.assume_role_arn
    session_name = var.atlantis_user
  }

}

resource "aws_s3_bucket" "tfstate" {
  bucket = "zerone-id-apnortheast2-tfstate"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_dynamodb_table" "terraform_state_locks" {
  name         = "terraform-locks"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
