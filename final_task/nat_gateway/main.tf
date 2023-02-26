resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.router_region
  network = var.router_network

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = var.nat_name
  router                             = var.nat_router
  region                             = var.nat_region
  nat_ip_allocate_option             = var.ip_allocation
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork
  
  # subnetwork {
  #   name = var.subnet_name
  #   source_ip_ranges_to_nat = var.ip_ranges 
  # }
}