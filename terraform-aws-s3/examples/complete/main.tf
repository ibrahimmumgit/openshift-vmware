######################################################################################################
# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#######################################################################################################

module "s3_bucket_01" {
  source = "../.."
  # source = "git::git@ssh.dev.azure.com:v3/petronasvsts/PETRONAS_AWS_IAC_Module/terraform-aws-s3?ref=v4-latest"

  create_bucket = true
  bucket        = local.bucket_name
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
  attach_policy                         = true
  attach_elb_log_delivery_policy        = false
  attach_lb_log_delivery_policy         = false
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
  policy                                = local.policy # custom policy in JSON

  # Logging
  logging = {
    target_bucket = module.log_bucket.name
    target_prefix = "log/"
  }

  # Intelligent Tiering
  intelligent_tiering = {
    general = { # Entire bucket Intelligent Tiering
      status = "Enabled"
      # filter = {
      #   prefix = "/"
      #   tags = {
      #     Environment = "dev"
      #   }
      # }
      tiering = {
        ARCHIVE_ACCESS = {
          days = 180
        }
      }
    }
    documents = { # You can also filter objects in the bucket with prefix and tags
      status = "Disabled"
      filter = {
        prefix = "documents/"
      }
      tiering = {
        ARCHIVE_ACCESS = {
          days = 125
        }
        DEEP_ARCHIVE_ACCESS = {
          days = 200
        }
      }
    }
  }
}

locals {
  bucket_name = "example-${random_integer.this.id}"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "arn:aws:s3:::${local.bucket_name}",
        "Principal" : { "AWS" : "${aws_iam_role.example.arn}" }
      }
    ]
  })
}
