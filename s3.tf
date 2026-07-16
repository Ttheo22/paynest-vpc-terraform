data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "paynest_bucket" {
  bucket = "${lower(var.project)}-logs-${data.aws_caller_identity.current.account_id}"

  tags = merge(local.common_tags, { Name = "${var.project}-bucket" })
}

resource "aws_s3_bucket_public_access_block" "paynest_bucket_public_access_block" {
  bucket = aws_s3_bucket.paynest_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "paynest_bucket_versioning" {
  bucket = aws_s3_bucket.paynest_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "paynest_bucket_encryption" {
  bucket = aws_s3_bucket.paynest_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

