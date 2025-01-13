## Docker Registry

- Create Registry

Use 1panel registry as upstream mirror for docker.io, avoid the network issue in China.

```bash
docker run -d -p 5000:5000 -e REGISTRY_PROXY_REMOTEURL=https://docker.1panel.live --name registry registry
```

- Set Mirror

Assume the registry endpoint is `http://192.168.31.110:5000`

Docker Daemon

```json
{
    "registry-mirrors": [
        "http://192.168.31.110:5000"
    ]
}
```

Kubernetes
Create `/etc/rancher/k3s/registries.yaml` described in [k3s Private Registry](https://docs.rancher.cn/docs/k3s/installation/private-registry/_index/)

```yaml
mirrors:
  "docker.io":
    endpoint:
      - http://192.168.31.110:5000
```