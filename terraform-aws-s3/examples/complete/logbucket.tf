######################################################################################################
# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#######################################################################################################

resource "random_integer" "this" {
  min = 100000
  max = 999999
}

module "log_bucket" {
  source = "../.."

  create_bucket = true
  bucket        = "${local.bucket_name}-access-logs"
  force_destroy = false

  # Object ownership
  control_object_ownership = false # or BucketOwnerEnforced. Bucket owner automatically owns and has full control over every object in the bucket. ACLs no longer affect permissions to data in the S3 bucket.

  # Block public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Bucket versioning
  versioning = {
    enabled    = false
    mfa_delete = false
  }

  # Default encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256" # Server-side encryption with Amazon S3 managed keys (SSE-S3)
        # sse_algorithm     = "aws:kms" # Server-side encryption with AWS Key Management Service keys (SSE-KMS)
        # kms_master_key_id = aws_kms_key.mykey.arn
      }
      bucket_key_enabled = false # Enable bucket key when using KMS to save costs
    }
  }

  # Object lock
  object_lock_enabled = false
  object_lock_configuration = {
    rule = {
      default_retention = {
        mode = "GOVERNANCE"
        days = 1
      }
    }
  }

  # Bucket policies
  attach_policy = true
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowS3ToWriteAccessLogs",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logging.s3.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::${local.bucket_name}-access-logs/*",
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:s3:::${local.bucket_name}"
          }
        }
      }
    ]
  })
}
