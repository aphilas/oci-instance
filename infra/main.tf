locals {
  # https://docs.oracle.com/en-us/iaas/images/ubuntu-2404/canonical-ubuntu-24-04-minimal-aarch64-2025-07-23-0.htm
  os_image_id = "ocid1.image.oc1.iad.aaaaaaaah5xqkk5zviea6hsxqk77ucvxzzx55rachmyvl2kmj2dz24usr3ca"
  node_shape  = "VM.Standard.A1.Flex"
  ssh_port    = 2222


  cloud_init_config = templatefile("${path.module}/cloud-init.yaml", {
    ssh_public_key     = file(var.ssh_public_key_file)
    ssh_port           = local.ssh_port
    user_password_hash = var.user_password_hash
  })
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

/* ------------------------------- Networking ------------------------------- */

module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.6.0"

  compartment_id = var.compartment_id

  vcn_name      = "spade-vcn"
  vcn_dns_label = "spade"
  vcn_cidrs     = ["10.0.0.0/16"]

  create_internet_gateway = true
  # create_nat_gateway      = false
  # create_service_gateway  = false
}

resource "oci_core_subnet" "spade-subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.1.0/24"

  display_name = "spade-subnet"
  dns_label    = "spadesubnet"

  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.spade-security-list.id]
}

/* -------------------------------- Security -------------------------------- */

resource "oci_core_security_list" "spade-security-list" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id

  display_name = "spade-security-list"

  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = local.ssh_port
      max = local.ssh_port
    }
  }

  # Allow ICMP ping
  ingress_security_rules {
    protocol    = "1" # ICMP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
  }

  egress_security_rules {
    protocol         = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

/* ---------------------------- Compute Instance ---------------------------- */

resource "oci_core_instance" "spade-instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id

  display_name = "spade"
  shape        = local.node_shape

  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }

  source_details {
    source_id   = local.os_image_id
    source_type = "image"

    boot_volume_size_in_gbs = 50 # Min size is 50GB
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.spade-subnet.id
    assign_public_ip = true
    hostname_label   = "spade"
  }

  metadata = {
    user_data = "${base64encode(local.cloud_init_config)}"
  }
}
