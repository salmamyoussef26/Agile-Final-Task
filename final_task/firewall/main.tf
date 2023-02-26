resource "google_compute_firewall" "allow-ssh-using-iap" {
  name    = var.ssh_firewall_name
  network = var.vpc_name

  allow {
    protocol = var.ssh_protocol
    ports    = var.ssh_ports
  }

  source_tags = var.vms_to_be_accessed
  source_ranges = var.iap-ip
}

resource "google_compute_firewall" "http" {
  name    = var.http_firewall_name
  network = var.vpc_name

  allow {
    protocol = var.http_protocol
    ports    = var.ssh_ports
  }

  direction     = "INGRESS"
  source_ranges = var.iap-ip
}