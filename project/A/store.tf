provider "google"{
  project = var.project_id
  credentials = file("tfservice.json")
  region = var.region
}

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

  //logging
  //log_bucket = projects/manifest-design-325305/locations/us-east1/buckets/my-log-bucket

  //log_bucket = "logging.googleapis.com/projects/manifest-design-325305/locations/australia-southeast2/buckets/logging-bucket1"

  log_bucket_id = "logging-bucket1"
  log_sink = "second-sink"
  logs_destination = "logging.googleapis.com/projects/manifest-design-325305/locations/australia-southeast2/buckets/logging-bucket1"

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
