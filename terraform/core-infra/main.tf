locals {
  project_id = "bcw-test-412305"

  region     = "asia-east1"
  zones = [
    "asia-east1-a",
    "asia-east1-b",
    "asia-east1-c",
  ]

  base_name = "bcw-test"

  default_labels = {
    managed-by = "terraform"
  }
}