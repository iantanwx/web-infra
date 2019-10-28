# clobbers all other bindings not managed by TF, as they are authoritative. be careful!
# only takes a single project for now. we manage roles on a per-project basis instead of globally.
resource "google_project_iam_binding" "project_iam_authoritative" {
  project  = var.project
  members  = var.members
  for_each = toset(var.roles)
  role     = each.value
}
