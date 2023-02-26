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
//variable "vm_project"{}