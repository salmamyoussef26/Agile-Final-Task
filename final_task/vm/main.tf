resource "google_compute_instance" "private-vm" {
  name         = var.vm_name
  machine_type = var.vm_type
  zone         = var.vm_zone

  tags = var.vm_tags

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    network = var.vm_network
    subnetwork = var.vm_subnet
  }

  service_account {
    email  = var.vm_sa
    scopes = var.vm_scopes
  }
}