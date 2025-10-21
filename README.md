# Oracle Compute Instance

> **Warning**
> This config is broken. SSH access does not work.

Oracle Cloud Compute Instance provisioned with Terraform (see infra/), used as a builder for ARM Docker images.

## Getting Started

```sh
# Provision instance
cd infra/
vim terraform.tfvars  # Set your variables
tf init
tf apply

# Add ssh config
tee -a ~/.ssh/config <<EOF
Host <host>
HostName <public_ip>
User ubuntu
Port 2222
IdentityFile ~/.ssh/id_ed25519
EOF

# Create docker context
docker context create <context> --docker "host=ssh://<host>"
DOCKER_CONTEXT=<context> docker ps
```
