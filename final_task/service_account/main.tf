resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = var.account_id
}

resource "google_project_iam_binding" "sa_iam" {
  for_each = var.roles
  project = var.project_id
  role    = each.value
  members  = var.sa_member
}

resource "google_service_account_key" "sa_key" {
  service_account_id = var.sa_name
}

resource "local_file" "myaccountjson" {
content     = var.key
filename = "${var.path}gke-vm-sa-key.json"
}