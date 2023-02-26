# Task requirements:
- Build GCP infrastructure using Teraaform.
- Create Dockerfile of the application.
- Build the Dockerfile and push its image to GCR.
- Create .yaml files to deploy the app on private GKE cluster.
------------------------------------

**1. Build GCP infrastructure using Terraform:**
```
.
├── firewall
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── gke
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── main.tf
├── nat_gateway
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── README.md
├── service_account
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── subnet
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── vm
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
└── vpc
    ├── main.tf
    ├── output.tf
    └── variables.tf

```
### 1. VPC Creation:

main.tf

```
resource "google_compute_network" "main-vpc" {
  name = var.vpc-name
  project = var.vpc-project
  auto_create_subnetworks = var.vpc-mode
}
```
variables.tf

```
variable "vpc-name"{
    type = string
}
variable "vpc-project"{
    type = string
}
variable "vpc-mode"{
    type = string
}
```
output.tf

```
output "vpc-name"{
    value = google_compute_network.main-vpc.name
}
output "vpc-id"{
    value = google_compute_network.main-vpc.id
}
```

vm module in main.tf
```
module "vpc"{
    source = "./vpc"
    vpc-name = "my-vpc"
    vpc-project = "salma-youssef-project"
    vpc-mode = false
}
```
--------------------------
### 2. Subnet Creation:

mani.tf

*. Management subnet:*
```
resource "google_compute_subnetwork" "management-subnet" {
name = var.manag-subnet-name
ip_cidr_range = var.manag-subnet-cidr
region = var.manag-subnet-region
network = var.subnet-network
private_ip_google_access = var.google_apis_access
}
```

*. Restricted Subnet:*

```
resource "google_compute_subnetwork" "restricted-subnet" {
name = var.restricted-subnet-name
ip_cidr_range = var.restricted-subnet-cidr
region = var.restricted-subnet-region
network = var.subnet-network
private_ip_google_access = var.google_apis_access
}
```
variables.tf

```
variable "manag-subnet-name"{
    type = string
}

variable "manag-subnet-cidr"{
    type = string
}

variable "manag-subnet-region"{
    type = string
}

variable "subnet-network"{
    type = string
}

variable "restricted-subnet-name"{
    type = string
}

variable "restricted-subnet-cidr"{
    type = string
}

variable "restricted-subnet-region"{
    type = string
}
variable "google_apis_access"{}
```

output.tf

```
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
```
subnet module in main.tf

```
module "subnet"{
    source = "./subnet"

    subnet-network = module.vpc.vpc-name
    google_apis_access = true
    
    //management subnet
    manag-subnet-name =  "management-subnet"
    manag-subnet-cidr = "10.0.0.0/24"
    manag-subnet-region = "us-east1"
    
    //restricted subnet
    restricted-subnet-name = "restricted-subnet"
    restricted-subnet-cidr = "10.0.1.0/24"
    restricted-subnet-region = "us-east4"


}
```
--------------------------------
### 3. VM:

main.tf
```
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
```
variables.tf
```
variable "vm_name"{}
variable "vm_type"{}
variable "vm_zone"{}
variable "vm_tags"{
    type = list
}
variable "vm_image"{}

variable "vm_network"{}
variable "vm_subnet"{}
variable "vm_sa"{}
variable "vm_scopes" {
    type = list
}
```
vm module in main.tf
```
module "vm"{
    source = "./vm"

    vm_name = "private-vm"
    vm_type = "f1-micro" 
    vm_zone = "us-east1-b"
    vm_tags = ["private-vm"]
    vm_image = "debian-cloud/debian-11"
    vm_network = module.vpc.vpc-name
    vm_subnet = module.subnet.manag_subnet_name
    vm_sa = module.sa.sa-email
    vm_scopes = ["cloud-platform"]
}
```
------------------

### 4. Firewall:

main.tf
```
resource "google_compute_firewall" "allow-ssh-using-iap" {
  name    = var.firewall_name
  network = var.vpc_name

  allow {
    protocol = var.protocol
    ports    = var.ports
  }

  source_tags = var.vms_to_be_accessed
  source_ranges = var.iap-ip
}
```

variables.tf
```
variable "firewall_name"{}
variable "vpc_name"{}
variable "protocol"{}
variable "ports"{
    type=list
}
variable "vms_to_be_accessed"{
    type = list
}
variable "iap-ip" {
  
}
```
firewall module in main.tf
```
module "firewall" {
    source = "./firewall"

    firewall_name = "allow-ssh-using-iap"
    vpc_name = module.vpc.vpc-name
    protocol = "tcp"
    ports = ["22"]
    vms_to_be_accessed = ["private-vm"]
    iap-ip = ["35.235.240.0/20"]
}
```
-----------------------------------------

### 5. NAT gateway:

main.tf
```
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
  
  subnetwork {
    name = var.subnet_name
    source_ip_ranges_to_nat = var.ip_ranges 
  }
}
```

variables.tf
```
variable "router_name"{}
variable "router_region" {}
variable "router_network"{}
variable "nat_name"{}
variable "nat_router"{}
variable "nat_region"{}
variable "ip_allocation"{}
variable "source_subnetwork"{}
variable "subnet_name"{}
variable "ip_ranges"{}
```

output.tf
```
output "router_name" {
  value = google_compute_router.router.name
}
output "router_region"{
    value = google_compute_router.router.region
}
```

nar module in main.tf
```
module "nat"{
    source = "./nat_gateway"

    //router
    router_name = "nat-router"
    router_region = module.subnet.manag_region_name
    router_network = module.vpc.vpc-id

    //nat
    nat_name = "my-nat"
    nat_router = module.nat.router_name
    nat_region = module.nat.router_region
    ip_allocation = "AUTO_ONLY"
    source_subnetwork = "LIST_OF_SUBNETWORKS"
    subnet_name = module.subnet.manag_subnet_name
    ip_ranges = ["ALL_IP_RANGES"]
    
}
```
-------------------------------

### 6. GKE Cluster

main.tf
```
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
  location   = var.node_pool_location
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
```

variables.tf
```
```

output.tf
```
```

gke module in main.tf