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
