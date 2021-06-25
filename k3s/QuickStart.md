Start install k3s and set env by this script, work on ubuntu.

Download and install k3s
```
curl -sfL https://get.k3s.io | sh -
```

Set docker as runtime
```
vim /etc/systemd/system/multi-user.target.wants/k3s.service

ExecStart=/usr/local/bin/k3s server --docker --no-deploy traefik
```

Set daocloud docker proxy
```
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
```

Restart docker and k3s
```
systemctl daemon-reload
service k3s restart
```

Install helm and set aliyun proxy
```
# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#set aliyun proxy
helm --kubeconfig /etc/rancher/k3s/k3s.yaml repo add helm-stable https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

#test repo
helm --kubeconfig /etc/rancher/k3s/k3s.yaml search repo nginx
```