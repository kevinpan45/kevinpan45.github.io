#Download and install golang
wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz

#Set golang bin path
export PATH=$PATH:/usr/local/go/bin
source ~/.profile

#Set proxy
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct