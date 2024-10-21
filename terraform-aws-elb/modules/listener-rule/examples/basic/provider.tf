provider "aws" {
  region = "ap-southeast-1"
  default_tags {
    tags = {
      Project_Code          = "" # Fill this out!
      CostCenter            = "" # Fill this out!
      ApplicationId         = "ALPHALNG"
      ApplicationName       = "ALPHA LNG"
      Environment           = "Development"
      DataClassification    = "Internal"
      SCAClassification     = "Standard"
      CSBIA_Confidentiality = "Major"
      CSBIA_Integrity       = "Major"
      CSBIA_Availability    = "Major"
      CSBIA_ImpactScore     = "Major"
      IACManaged            = true
      IACRepo               = "" # Fill this out!
      ProductOwner          = "" # Fill this out!
      ProductSupport        = "" # Fill this out!
      BusinessOwner         = "" # Fill this out!
      BusinessStream        = "Gas and New Energy"
      BusinessOPU_HCU       = "Malaysia LNG Sdn Bhd"
    }
  }
}
