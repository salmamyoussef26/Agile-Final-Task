output "vpc-name"{
    value = google_compute_network.main-vpc.name
}

output "vpc-id"{
    value = google_compute_network.main-vpc.id
}