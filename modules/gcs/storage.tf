resource "google_storage_bucket" "gcs_storage"{
  project = var.project_id
  name = var.name
  location      = var.region
  storage_class = "STANDARD"
  versioning{
    enabled = true
  }
  requester_pays = true

  uniform_bucket_level_access = true

  labels = {
    confidentiality = var.confidentiality
    integrity = var.integrity
    trustlevel = var.trustlevel
  }

  cors {
   origin          = var.origin
   method          = var.method
   response_header = var.response_header
   max_age_seconds = 3600
 }

 logging {
   log_bucket = var.logs_destination
 }

}

/*
resource "google_storage_bucket_object" "browser.txt" {
    for_each = toset(var.sub_folders)
    name = each.key
    content = "This is just a mock"
    bucket = google_storage_bucket.gcs_storage.name
    depends_on = [google_storage_bucket.gcs_storage]
}
*/

resource "google_storage_bucket_iam_binding" "role_binding" {
    for_each = var.bucket_iam
    bucket = google_storage_bucket.gcs_storage.name
    role = each.value.role
    members = each.value.members
}

resource "google_logging_project_bucket_config" "basic" {
    project    = var.project_id
    location  = var.region
    retention_days = 30
    bucket_id = var.log_bucket_id
}

resource "google_logging_project_sink" "instance-sink" {
  name        = var.log_sink
  destination = var.logs_destination
  //filter      = var.filtering
  //destination = "logging.googleapis.com/projects/${google_storage_bucket.gcs_storage.project}/locations/${google_storage_bucket.gcs_storage.location}/buckets/${google_logging_project_sink.basic.bucket_id}"

  unique_writer_identity = true
}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "log-writer" {
  project = var.project_id
  role = "roles/storage.objectCreator"

  members = [
    "user:mourya.konakandla8@gmail.com",
  ]
}
