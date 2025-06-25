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
```

### Access Argo-Workflows

Argo Workflows is not accessible by default. You can access it via a LoadBalancer service or port-forwarding. After that, you can access the Argo Workflows UI at `https://<your-ip>:2746`.

#### LoadBalancer (Recommended)

```bash
# Update Argo Service to LoadBalancer Type
autok3s kubectl patch svc argo-server -n argo -p '{"spec":{"type":"LoadBalancer","ports":[{"name":"web","port":2746,"targetPort":2746}]}}'
# Verify LoadBalancer Assignment, Check if the LoadBalancer has been assigned an external IP
autok3s kubectl get svc argo-server -n argo
# By default, argo-server expects to be accessed with a `/argo/` base path. If you want to access it directly at the root path, update the deployment
autok3s kubectl patch deployment argo-server -n argo -p '{"spec":{"template":{"spec":{"containers":[{"name":"argo-server","env":[{"name":"ARGO_BASE_HREF","value":"/"}]}]}}}}'
```

#### Port Forward

Kubernetes streamingConnectionIdleTimeout mechanism will stop the port forward after 4 hours. You need to restart the port forward command manually after that, unrecommended for production use.

```bash
nohup autok3s kubectl -n argo port-forward --address 0.0.0.0 service/argo-server 2746:2746 > port-forward.log 2>&1 &
```

### Set Mirror Registry for Kubernetes (Optional)

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
sudo systemctl daemon-reload
sudo systemctl restart k3s
```