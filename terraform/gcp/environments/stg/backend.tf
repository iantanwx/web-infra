terraform {
 backend "gcs" {
   credentials = "~/.config/gcloud/corpnavi-terraform-admin.json"
   bucket  = "corpnavi-terraform-admin"
   prefix  = "terraform/stg/state"
 }
}
