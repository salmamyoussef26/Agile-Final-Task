variable "ssh_firewall_name"{}
variable "http_firewall_name"{}
variable "vpc_name"{}
variable "ssh_protocol"{}
variable "http_protocol" {}
variable "ssh_ports"{
    type=list
}

variable "http_ports"{
    type=list
}

variable "vms_to_be_accessed"{
    type = list
}
variable "iap-ip" {
  
}
