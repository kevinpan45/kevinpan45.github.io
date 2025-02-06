Install Argo-Workflows in Local Cluster 

- [Offical Doc](https://argo-workflows.readthedocs.io/en/latest/quick-start/)
- Work on
    - autok3s
    - Argo-Workflows: 3.6.2

```bash
# install Argo-Workflows
export ARGO_WORKFLOWS_VERSION="v3.6.2"
autok3s kubectl create namespace argo
autok3s kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"
# forward port to local
nohup autok3s kubectl -n argo port-forward --address 0.0.0.0 service/argo-server 2746:2746 > port-forward.log 2>&1 &
```

***Set Mirror Registry for Kubernetes (Optional for China)***

Sample of k3s and daocloud mirror

Create `/etc/rancher/k3s/registries.yaml` described in [k3s Private Registry](https://docs.rancher.cn/docs/k3s/installation/private-registry/_index/)

```yaml
mirrors:
  "docker.io":
    endpoint:
      - https://docker.m.daocloud.io
```

then restart k3s service

```bash
sudo systemctl restart k3s
```