terraform {
 backend "gcs" {
   bucket  = "corpnavi-terraform-admin"
   prefix  = "terraform/internal/state"
 }
}
