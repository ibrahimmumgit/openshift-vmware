######################################################################################################
# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#######################################################################################################

module "dynamodb_table_01" {
  source = "../.."
  # source = "git::git@ssh.dev.azure.com:v3/petronasvsts/PETRONAS_AWS_IAC_Module/terraform-aws-dynamodb?ref=v5.0-latest"

  create_table        = true
  name                = "example-dynamodb-name"
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
