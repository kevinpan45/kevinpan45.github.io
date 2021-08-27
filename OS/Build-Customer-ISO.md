# Description
How do web usually build a custom image
1. Create a virtual machine(VM)
2. SSH to VM
3. Set networking
4. Set system config
5. Install software
6. Clean instal package
7. Clean system ops mark
8. Build image by virtualization management platform or software

Case Problems
* Create VM takes a long time
* Ops need watching
* Ops need people learn relate tech knowledge
* Huge cost when need retry or restart process
* Image available cannot be test

Design Goals
* Unattended
* Testability
* Easy to execute
* Configuration Templating

Design Ideas
* Packer : Generate basic virtual machine image with customer software and system settings, configuration templating
* Kickstart : Auto install configuration, avoid OS install process
* genisoimage : VM image to ISO image for regular boot or UEFI secure boot

## Build Virtual Machine image by HashiCorp Packer
Configuration scope:
* Basic OS image
* Disk partition strategy
* Network setting
* Custom softwares
* Custom scripts execution

## Writter Kickstart File

kickstart file
```
# OS Layer 

# Disk partition

# Networking

# Init software in OS rpm folder 

# Scripts Execution



```

## Create an Installer ISO Image with a Custom Installation or Upgrade Script


## Reference
- https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.upgrade.doc/GUID-C03EADEA-A192-4AB4-9B71-9256A9CB1F9C.html
- https://gmusumeci.medium.com/how-to-use-packer-to-build-a-centos-template-for-vmware-vsphere-dea37d95b7b1
- https://gist.github.com/szurcher/12a1546eb610e1e7ebb65b6feca468ac