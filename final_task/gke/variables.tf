variable "cluster_name"{}
variable "cluster_location"{}
variable "cluster_network"{}
variable "cluster_subnet"{}
variable "node_pool"{}
variable "node_count"{}

//private config
variable "enable_private_endpoint"{}
variable "enable_private_nodes"{}
variable "master_ip"{}

//authosized network
variable "manag-subnet-cidr"{}
variable "manag-subnet-name" {}

//node pool
variable "node_machine_type"{}
variable "node_pool_name"{}
#variable "node_pool_location" {}
variable "node_pool_cluster"{}
variable "node_pool_count"{}

variable "sa-email"{}