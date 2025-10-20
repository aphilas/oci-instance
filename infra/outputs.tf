output "public_ip" {
  description = "The public IP address of the spade instance"
  value       = oci_core_instance.instance.public_ip
}

output "user" {
  description = "The default user for the spade instance"
  value       = "ubuntu"
}

output "ssh_command" {
  description = "The SSH command to connect to the spade instance"
  value       = "ssh -i ${var.ssh_private_key_file} -p ${local.ssh_port} ubuntu@${oci_core_instance.instance.public_ip}"
}
