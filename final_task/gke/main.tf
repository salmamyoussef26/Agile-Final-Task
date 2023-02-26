resource "google_container_cluster" "private-cluster" {
  name     = var.cluster_name
  location = var.cluster_location
  remove_default_node_pool = var.node_pool
  initial_node_count  = var.node_count
  network = var.cluster_network
  subnetwork = var.cluster_subnet

    ip_allocation_policy {
    # cluster_secondary_range_name  = "k8s-pod-range"
    # services_secondary_range_name =  "k8s-services-range"
  }

   private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ip
  }

    master_authorized_networks_config {
    cidr_blocks {
        cidr_block = var.manag-subnet-cidr 
        display_name = var.manag-subnet-name
    }
    }

      addons_config {
    http_load_balancing {
      disabled = true
    }
  }


 release_channel {
    channel = "REGULAR"
  }


}

resource "google_container_node_pool" "private-node-pool" {
  name       = var.node_pool_name
  # location   = var.node_pool_location
  cluster    = var.node_pool_cluster
  node_count = var.node_pool_count

  node_config {
    preemptible  = true
    machine_type = var.node_machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = var.sa-email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}