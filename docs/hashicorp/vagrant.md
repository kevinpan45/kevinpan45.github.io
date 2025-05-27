## Quick Start

Quick start guide for [Vagrant](https://developer.hashicorp.com/vagrant/tutorials/get-started).

- [Install Vagrant CLI](https://developer.hashicorp.com/vagrant/install)
- [Install Oracle VirtualBox as VM Provider](https://www.virtualbox.org/wiki/Linux_Downloads)

```bash
# Import Oracle public key
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
# Add VirtualBox repository
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian noble contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
# Install VirtualBox
sudo apt update
sudo apt install virtualbox-7.0
vboxmanage --version
```

## Create Vagrant project

Create [Dokploy](https://dokploy.com/) server to as a Vagrant project showcase.

- make a work directory, like ~/vms/dokploy
- go to the directory
- create a Vagrantfile `vim Vagrantfile`
- copy the following code into the Vagrantfile

```vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.network "public_network", bridge: "enp7s0", ip: "192.168.31.224"

  config.vm.synced_folder ".", "/vagrant", disabled: true


  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192" # 8GB
    vb.cpus = 2 # 2 CPUs
  end

  config.vm.provision "shell", inline: <<-SHELL
    # use tsinghua apt source https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse" | sudo tee /etc/apt/sources.list
    apt update
  SHELL
end
```
- start vm by `vagrant up`
- ssh into the vm by `vagrant ssh`
- change root password by `sudo passwd`
- change to root user 
- install Docker by `curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun`
- set ADVERTISE_ADDR to environment variable by `export ADVERTISE_ADDR=192.168.31.224`
- install Dokploy by `curl -sSL https://dokploy.com/install.sh | sh`
