######################################################################################################
# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#######################################################################################################

provider "aws" {
  region = "ap-southeast-1"
  assume_role {
    role_arn = "arn:aws:iam::964323286598:role/PTAWSG_PROD_ENVIRONMENT_02_PROVISION_ROLE"
  }
  default_tags {
    tags = {
      Project_Code          = "COC-LAB"
      CostCenter            = "704D905153"
      ApplicationId         = "Common - COC"
      ApplicationName       = "COC Dedicated Account for Development"
      Environment           = "Development"
      DataClassification    = "Missing"
      SCAClassification     = "Missing"
      CSBIA_Confidentiality = "Missing"
      CSBIA_Integrity       = "Missing"
      CSBIA_Availability    = "Missing"
      CSBIA_ImpactScore     = "Missing"
      IACManaged            = "true"
      IACRepo               = "NA"
      ProductOwner          = "sazali.mokhtar@petronas.com.my"
      ProductSupport        = "InfraServices_COC_CloudOps@petronas.com.my"
      BusinessOwner         = "sazali.mokhtar@petronas.com.my"
      BusinessStream        = "PDnT"
      BusinessOPU_HCU       = "PETRONAS Digital Sdn Bhd"
    }
  }
}

// Create temporary random id for testing purposes and get caller accountid
run "setup" {
  module {
    source = "./tests/setup"
  }
}

// Create S3 Bucket
run "create_s3_bucket" {
  command = apply

  variables {
    create_bucket = true
    bucket        = "test-bucket-tf-${run.setup.random_number}"
    force_destroy = true

    # Object ownership
    control_object_ownership = false # or BucketOwnerEnforced. Bucket owner automatically owns and has full control over every object in the bucket. ACLs no longer affect permissions to data in the S3 bucket.

    # Block public access
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true

    # Bucket versioning
    versioning = {
      enabled    = true
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
    policy                                = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "s3:ListBucket",
          "Resource" : "arn:aws:s3:::test-bucket-tf-${run.setup.random_number}",
          "Principal" : { "AWS" : "arn:aws:iam::${run.setup.account_id}:root" }
        }
      ]
    })

    # Intelligent Tiering
    intelligent_tiering = {
      general = {
        status = "Enabled"
        filter = {
          prefix = "/"
          tags = {
            Environment = "dev"
          }
        }
        tiering = {
          ARCHIVE_ACCESS = {
            days = 180
          }
          DEEP_ARCHIVE_ACCESS = {
            days = 200
          }
        }
      }
    }
  }

  assert {
    condition = length(aws_s3_bucket.this) == 1
    error_message = "S3 bucket failed to create"
  }

  assert {
    condition = aws_s3_bucket_public_access_block.this[0].block_public_acls && aws_s3_bucket_public_access_block.this[0].block_public_policy && aws_s3_bucket_public_access_block.this[0].ignore_public_acls && aws_s3_bucket_public_access_block.this[0].restrict_public_buckets
    error_message = "S3 bucket public access block failed to set"
  }

  assert {
    condition = aws_s3_bucket_versioning.this[0].versioning_configuration[0].status == "Enabled"
    error_message = "S3 bucket versioning failed to set"
  }

  assert {
    condition = one(aws_s3_bucket_server_side_encryption_configuration.this[0].rule).apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "S3 bucket default encryption failed to set"
  }

  assert {
    condition = length(aws_s3_bucket_policy.this) > 0
    error_message = "S3 bucket policy not set"
  }

  assert {
    condition = length(aws_s3_bucket_intelligent_tiering_configuration.this) > 0
    error_message = "S3 bucket intelligent tiering not set"
  }
}