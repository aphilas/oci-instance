provider "oci" {
  region = var.region

  user_ocid   = var.user_id
  private_key = file(var.private_key_file)
  fingerprint = var.fingerprint
}
