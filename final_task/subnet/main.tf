resource "google_compute_subnetwork" "management-subnet" {
name = var.manag-subnet-name
ip_cidr_range = var.manag-subnet-cidr
region = var.manag-subnet-region
network = var.subnet-network
private_ip_google_access = var.google_apis_access
}

resource "google_compute_subnetwork" "restricted-subnet" {
name = var.restricted-subnet-name
ip_cidr_range = var.restricted-subnet-cidr
region = var.restricted-subnet-region
network = var.subnet-network
private_ip_google_access = var.google_apis_access
}