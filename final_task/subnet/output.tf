output "manag_subnet_name"{
    value = google_compute_subnetwork.management-subnet.name
}

output "manag_region_name"{
    value = google_compute_subnetwork.management-subnet.region
}

output "restricted_subnet_name" {
  value = google_compute_subnetwork.restricted-subnet.name
}

output "manag-subnet-cidr" {
  value = google_compute_subnetwork.management-subnet.ip_cidr_range
  
}