locals {
  final_name = "bcw-${random_id.bucket_prefix.hex}-tfstate"
  main_region = "ASIA"
}

resource "google_kms_key_ring" "terraform_state" {
  name     = local.final_name
  location = lower(local.main_region)
}

resource "google_kms_crypto_key" "terraform_state_bucket" {
  name            = local.final_name
  key_ring        = google_kms_key_ring.terraform_state.id
  rotation_period = "86400s"

  lifecycle {
    prevent_destroy = false
  }
}

data "google_project" "project" {
}

resource "google_project_iam_member" "default" {
  project = data.google_project.project.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name          = local.final_name
  force_destroy = false
  location      = local.main_region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state_bucket.id
  }
  depends_on = [
    google_project_iam_member.default
  ]
}
