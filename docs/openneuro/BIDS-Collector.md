Collect BIDS Dataset from OpenNeuro to Specific Object Storage(S3/OSS/Other S3 Compatible)

[Official Supported Tools](https://docs.openneuro.org/#advanced-usage)

- s3
- Node.js CLI
- Datalad

All these tools is download to local env, it's not so convenient if you want to restore to specific object storage.

## Ways to Transfer BIDS Dataset to Specific Object Storage

### Rclone

1. Create Config File 
`rclone.config`
```plaintext
[minio]
type = s3
provider = Minio
env_auth = false
access_key_id = <>
secret_access_key = <>
region = <>
endpoint = <>

[s3]
type = s3
provider = AWS
endpoint = https://s3.amazonaws.com
```

```bash
# sample of OpenNeuro ds005700
sync s3:openneuro.org/ds005700 minio:openneuro/ds005700 --verbose
```

#### Rclone Execution on Pipeline Platform

##### Argo-Workflows

- Create Argo-Workflows Template

```yaml
apiVersion: argoproj.io/v1alpha1
kind: WorkflowTemplate
metadata:
  name: openneuro-collector
  namespace: bids-collector
  generateName: openneuro-collector-
spec:
  entrypoint: rclone
  arguments:
    parameters:
    - name: dataset
      description: Accession number of the dataset
  templates:
    - name: rclone
      inputs:
        parameters:
        - name: dataset
      container:
        image: rclone/rclone:latest
        command: ["rclone"]
        args:
          - "sync"
          - "s3:openneuro.org/{{workflow.parameters.dataset}}"
          - "minio:bids/{{workflow.parameters.dataset}}"
          - "--verbose"
        volumeMounts:
          - name: rclone-openneuro
            mountPath: /root/.config/rclone/
            readOnly: true
      volumes:
        - name: rclone-openneuro
          configMap:
            name: rclone-openneuro
```

- Submit Workflow

```bash
argo submit openneuro-collector.yaml -p dataset=ds005700
```

##### HashiCorp Nomad
    
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