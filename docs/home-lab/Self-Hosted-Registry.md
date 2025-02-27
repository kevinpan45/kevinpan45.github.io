# Sefl-Hosted Registry

If you have multiple docker envs or kubernetes nodes, it's better to create a self-hosted registry to serve the images, avoid the network issue and improve the deployment speed.

CNCF Distribution is lightweight and easy to deploy than Harbor, it's a better choice for home lab and small team.

***Docker Registry is [deprecated](https://docs.docker.com/retired/#registry-now-cncf-distribution), replaced by [CNCF Distribution](https://distribution.github.io/distribution/).***

## Docker Distribution

- Create Registry Config

Refer to [Configuring a registry](https://distribution.github.io/distribution/about/configuration/), create a `config.yml` file.

```yaml
version: 0.1
log:
  fields:
    service: registry
storage:
    delete:
      enabled: true
    cache:
        blobdescriptor: inmemory
    filesystem:
        rootdirectory: /var/lib/registry
    maintenance:
        uploadpurging:
            enabled: false
http:
    addr: :5000
    headers:
        X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
proxy:
  remoteurl: https://registry-1.docker.io
  ttl: 168h
```

- Run Registry

***mount the created `config.yml` to `/etc/docker/registry/config.yml`***

```bash
docker run -d -p 5000:5000 --restart=always --name registry -v ./config.yml:/etc/docker/registry/config.yml registry:2
```

***China mainland users need to set the http proxy to avoid the GFW.***

```bash
docker run -d -p 5000:5000 --restart=always -e HTTP_PROXY=<> -e HTTPS_PROXY=<> --name registry -v ./config.yml:/etc/docker/registry/config.yml registry:2
```


- Set Mirror

Assume the registry endpoint is `http://192.168.31.110:5000`

Docker Daemon

Create `/etc/docker/daemon.json` described in [Configure the Docker daemon](https://docs.docker.com/docker-hub/image-library/mirror/#configure-the-docker-daemon)

```json
{
    "registry-mirrors": [
        "http://192.168.31.110:5000"
    ]
}
```

then restart the docker daemon

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Kubernetes

Create `/etc/rancher/k3s/registries.yaml` described in [k3s Private Registry](https://docs.rancher.cn/docs/k3s/installation/private-registry/_index/)

```yaml
mirrors:
  "docker.io":
    endpoint:
      - http://192.168.31.110:5000
```

## Advanced

### S3 as Storage

CNCF Distribution support [S3 Storage](https://distribution.github.io/distribution/storage-drivers/s3/) as backend storage, it's better to separate the storage from the registry container, so you can rebuild or transfer the registry easily.

sample of `config.yml` 

```yaml
version: 0.1
log:
  fields:
    service: registry
storage:
  cache:
    blobdescriptor: inmemory
  s3:
    accesskey: <>
    secretkey: <>
    region: <>
    regionendpoint: <>
    bucket: <>
    loglevel: debug
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
proxy:
  remoteurl: https://registry-1.docker.io
  ttl: 168h
```