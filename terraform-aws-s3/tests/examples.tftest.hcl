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

run "complete" {
  module {
    source = "./examples/complete"
  }
}

run "basic" {
  module {
    source = "./examples/basic"
  }
}