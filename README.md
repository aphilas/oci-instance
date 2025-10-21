# Oracle Compute Instance

> **Warning**
> This config is broken. SSH access does not work.

Oracle Cloud Compute Instance, used (for now) as a builder for ARM Docker images.

## Troubleshooting

- Check serial console logs for errors

```
sudo less /var/log/cloud-init-output.log
```

## Docker context

```sh
docker context create <context> --docker "host=ssh://<host>"

DOCKER_CONTEXT=<context> docker ps
```

## References

- https://docs.oracle.com/en-us/iaas/Content/dev/terraform/tutorials/tf-vcn.htm
- https://cloudinit.readthedocs.io/en/latest/reference/examples.html
- https://cloudinit.readthedocs.io/en/latest/reference/yaml_examples/user_groups.html
- https://community.hetzner.com/tutorials/basic-cloud-config - cloud-init example
