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

// Create temporary kms key for testing purposes and get caller accountid
run "setup" {
  module {
    source = "./tests/setup"
  }
}

// Create an autoscaled DynamoDB table
run "create_autoscale_dynamodb" {
  command = apply

  variables {
    name                = "example-autoscaled-dynamodb-name"
    hash_key            = "example-dynamodb-hash-key"
    range_key           = "example-dynamodb-range-key"
    billing_mode        = "PROVISIONED"
    read_capacity       = 10
    write_capacity      = 10
    autoscaling_enabled = true

    autoscaling_read = {
      scale_in_cooldown  = 10
      scale_out_cooldown = 100
      target_value       = 80
      min_capacity       = 10
      max_capacity       = 100
    }

    autoscaling_write = {
      scale_in_cooldown  = 10
      scale_out_cooldown = 100
      target_value       = 80
      min_capacity       = 10
      max_capacity       = 100
    }

    attributes = [
      {
        name = "example-dynamodb-hash-key"
        type = "S"
      },
      {
        name = "example-dynamodb-range-key"
        type = "S"
      }
    ]
  }

  assert {
    condition = length(aws_dynamodb_table.autoscaled) == 1
    error_message = "Autoscaled DynamoDB table created failed"
  }
}

// Create an On-Demand DynamoDB table
run "create_on-demand-dynamodb" {
  command = apply

  variables {
    name                = "example-on-demand-dynamodb-name"
    hash_key            = "example-dynamodb-hash-key"
    range_key           = "example-dynamodb-range-key"
    billing_mode        = "PAY_PER_REQUEST"
    attributes = [
      {
        name = "example-dynamodb-hash-key"
        type = "S"
      },
      {
        name = "example-dynamodb-range-key"
        type = "S"
      }
    ]
  }

  assert {
    condition = length(aws_dynamodb_table.this) == 1
    error_message = "On-Demand DynamoDB table created failed"
  }
}
