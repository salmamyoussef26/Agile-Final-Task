resource "google_compute_network" "main-vpc" {
  name = var.vpc-name
  project = var.vpc-project
  auto_create_subnetworks = var.vpc-mode
}