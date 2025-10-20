variable "user_id" {
  type        = string
  description = "The OCID of the user to authenticate as"
}

variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
}

variable "region" {
  type        = string
  description = "The region to provision the resources in"
}

variable "private_key_file" {
  type        = string
  description = "Path to the Oracle Cloud API signing private key file"
}

variable "fingerprint" {
  type        = string
  description = "The fingerprint for the API signing key"
}

variable "ssh_public_key_file" {
  type        = string
  description = "Path to the SSH public key file"
}

variable "ssh_private_key_file" {
  type        = string
  description = "Path to the SSH private key file"
}

variable "username" {
  type        = string
  description = "The default username for the VM"
}

variable "console_user_passwd" {
  type        = string
  description = "The hashed password for the console user. Generated using `openssl passwd -1 'your_password'`"
}
