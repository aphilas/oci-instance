# spade

> **Warning**
> This config is broken. SSH access does not work.

Oracle Cloud Compute Instance, used (for now) as a builder for ARM Docker images.

Spec:

- Ingress: TCP 22 (SSH)
- Egress: All

## Getting started

```sh
oci session authenticate
oci session refresh

export OCI_CLI_AUTH=security_token
export OCI_CLI_PROFILE=spade

# Verity authn
oci iam region list
```

TODO:

- Fix SSH access
- Ensure default security list is not applied
- Allow ICMP and other pings
- Add fail2ban
- Enable Oracle monitoring agents
- Fix existing user vs new user config
- Set up VM to test cloud init script locally
- Switch provider to public key auth 

## Troubleshooting

- Check serial console logs for errors

```
sudo less /var/log/cloud-init-output.log
```

## References

- https://docs.oracle.com/en-us/iaas/Content/dev/terraform/tutorials/tf-vcn.htm
- https://cloudinit.readthedocs.io/en/latest/reference/examples.html
- https://cloudinit.readthedocs.io/en/latest/reference/yaml_examples/user_groups.html
- https://community.hetzner.com/tutorials/basic-cloud-config - cloud-init example
