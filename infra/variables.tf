variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
}

variable "region" {
  type        = string
  description = "The region to provision the resources in"
}

variable "ssh_public_key_file" {
  type        = string
  description = "Path to the SSH public key file"
}

variable "ssh_private_key_file" {
  type        = string
  description = "Path to the SSH private key file"
}
