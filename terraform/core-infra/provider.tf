terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.2"
    }
  }

  backend "gcs" {
    bucket = "bcw-eb4c0a3f0bb6c5d0-tfstate"
    prefix = "terraform/state/core-infra"
  }
}


provider "google" {
  project = local.project_id
  region  = local.region
}

provider "google-beta" {
  project = local.project_id
  region  = local.region
}

data "google_project" "this" {}

data "google_compute_default_service_account" "default" {}
