resource "google_service_account" "gcs-service1"{
  account_id = "gcs-service1"
  display_name = "Workload identity to run transactions pipeline"
  project = var.project_id
}

module "test_bucket"{
  source = "../../modules/gcs"
  name = "mouryak1"
  project_id = var.project_id
  region = var.region

  // sub_folders = ["transactions/staging/", "transactions/tmp/"]

  //mandatory labels
  confidentiality = "internal"
  integrity = "trusted"
  trustlevel = "medium"

  //CORS Configurations
  origin = ["http://image-store.com"]
  method = ["GET", "HEAD", "PUT", "POST", "DELETE"]
  response_header = ["*"] 

  bucket_iam = {
    bucket_read = {
      role = "roles/storage.objectViewer"
      members = [
        "serviceAccount:${google_service_account.gcs-service1.email}"
      ]
    }

    bucket_writer = {
      role = "roles/storage.objectCreator"
      members = [
        "serviceAccount:${google_service_account.gcs-service1.email}"
      ]
    }
  }
}
