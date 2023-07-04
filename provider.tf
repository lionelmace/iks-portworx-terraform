##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.3"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.54.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.1"
    }
  }
}

provider "ibm" {
  region = var.region
}

##############################################################################