## Quick Start
Quick start guide for [Nomad](https://developer.hashicorp.com/nomad/tutorials/get-started?in=nomad/get-started).

This doc base on these precondition:

- Local Stack runs on a Linux host.
- Nomad config as system service on the host.
- Nomad server and client run on the host.

## Config

### Server Config

`vim /etc/nomad.d/nomad.hcl`

```hcl
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Full configuration options can be found at https://www.nomadproject.io/docs/configuration

data_dir  = "/opt/nomad"
bind_addr = "0.0.0.0
```

`vim /etc/nomad.d/server.hcl`

```hcl
server {
  enabled          = true
  bootstrap_expect = 1
}
```

### Client Config

`vim /etc/nomad.d/client.hcl`

```hcl
client {
  enabled = true
  servers = ["127.0.0.1"]
  options {
    "docker.cleanup.image" = "false"
  }
  host_volume "local-stack" {
    path      = "/data/local-stack"
    read_only = false
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

plugin "docker" {
  config {
    allow_privileged = true
    volumes {
      enabled      = true
    }
  }
  node_pool = "default"
}
```

`mkdir /data/local-stack` for `host_volume` block, jobs can use this volume to mount folder in task.

### Global Job Variables

- Create a variable specification file named "spec.nv.hcl"

```bash
nomad var init
```

- Add variables to the file for all jobs

```hcl
# A variable path can be specified in the specification file
# and will be used when writing the variable without specifying a
# path in the command or when writing JSON directly to the `/var/`
# HTTP API endpoint
path = "nomad/jobs"

# The Namespace to write the variable can be included in the specification. This
# value can be overridden by specifying the "-namespace" flag on the "put"
# command.
# namespace = "default"

# The items map is the only strictly required part of a variable
# specification, since path and namespace can be set via other means.
# It contains the sensitive material to encrypt and store as a Nomad
# variable. The entire items map is encrypted and decrypted as a
# single unit.

# REMINDER: While keys in the items map can contain dots, using them
# in templates is easier when they do not. As a best practice, avoid
# dotted keys when possible.
items {
  MINIO_ENDPOINT     = ""
  MINIO_ACCESS_KEY   = ""
  MINIO_SECRECT_KEY  = ""
}

```

add your variables for all jobs into the `items` block, K/V format, like `MINIO_ACCESS_KEY` and `MINIO_SECRECT_KEY` above.

- Run command to put variables into Nomad.
    
```bash
nomad var put @spec.nv.hcl
```

## Job Sample
This sample is a job to sync OpenNeuro dataset to MinIO.

Key points:

1. Docker driver
2. Use `template` block to write config file into docker container
3. Use `nomadVar` function to get global variables defined in `nomad/jobs` path
3. Use `mounts` block to add config file write by `template` block
4. Use `var` to set variable for job

### Steps:

- Create job file

`vim openneuro.nomad.hcl`

```hcl
// run with var dataset
variable "dataset" {
  type = string
}

job "openneuro-dataset-sync-to-minio" {
  datacenters = ["dc1"]
  type        = "batch"
  group "dataset-sync" {
    task "openneuro" {
      driver = "docker"

      template {
        data        = <<EOF
                        {{- with nomadVar "nomad/jobs" -}}
                        [minio]
                        type = s3
                        provider = Minio
                        env_auth = false
                        access_key_id = {{ .MINIO_ACCESS_KEY }}
                        secret_access_key = {{ .MINIO_SECRECT_KEY }}
                        region =
                        endpoint = {{ .MINIO_ENDPOINT}}

                        [s3]
                        type = s3
                        provider = AWS
                        endpoint = https://s3.amazonaws.com
                        {{- end }}
                      EOF
        destination = "local/rclone.conf"
      }

      config {
        image = "rclone/rclone:latest"
        args  = ["sync", "s3:openneuro.org/${var.dataset}", "minio:openneuro/${var.dataset}", "--verbose"]
        mounts = [
          {
            type = "bind"
            source = "local"
            target = "/config/rclone/"
          }
        ]
      }
    }
  }
}
```

- Run job

```bash
nomad job run -var="dataset=ds004776" openneuro.nomad.hcl
```

## Optional

### Nomad Pack

1. Install Nomad Pack : https://github.com/hashicorp/nomad-pack-community-registry

2. add default registry
```bash
nomad-pack registry add default https://github.com/hashicorp/nomad-pack-community-registry
```