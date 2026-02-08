## STEPS

export CLUSTER_IP="3.17.116.249"

# Install containerd
# This will isntall RunD and ContainerD
sudo yum install containerd

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF


# Apply sysctl params without reboot
sudo sysctl --system

# containerd  config
containerd config default > /etc/containerd/config.toml


# Modify manually
# I'm using systemd as a cgropus driver on contianerD as it is the default option for k8s too.

[plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.runc]
  ...
  [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.runc.options]
    SystemdCgroup = true

# Restart contianerD
sudo systemctl restart containerd
# check sandbox image is set up

## Networking

dnf install iptables

# CNI Plugins
# Taken from https://github.com/containernetworking/plugins/releases/tag/v1.9.0
wget -O cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v1.9.0/cni-plugins-linux-arm-v1.9.0.tgz
mkdir -p /opt/cni/bin/
tar xvfx cni-plugins.tgz -C /opt/cni/bin/

# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


# Adding yum repository for K8s
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# This overwrites any existing configuration in /etc/yum.repos.d/kubernetes.repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.35/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.35/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet


cat <<EOF | sudo tee ./init_cluster_config.yml
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
controlPlaneEndpoint: "$CLUSTER_IP:6443"
networking:
  dnsDomain: cluster.local
  podSubnet: "10.217.0.0/16"
  serviceSubnet: "10.96.0.0/12"
apiServer:
  extraArgs:
    advertise-address: "$CLUSTER_IP"
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
nodeRegistration:
  name: "cp"
  criSocket: "unix:///run/containerd/containerd.sock"
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: "systemd"
shutdownGracePeriod: 5m0s
shutdownGracePeriodCriticalPods: 5m0s
---
EOF

kubeadm init --v=9 --config=./init_cluster_config.yml

# Taint as cilium will needed it
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#export USER_HOME="/home/ec2-user"
#mkdir -p $USER_HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $USER_HOME/.kube/config
#sudo chown $(id -u):$(id -g) $USER_HOME/.kube/config

# Cilium
# https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/#install-the-cilium-cli
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}


/usr/local/bin/cilium install --version 1.19.0 --set hubble.ui.enabled=true --set hubble.relay.enabled=true --set operator.replicas=1 --set hubble.relay.tls.server.enabled=false --set hubble.tls.enabled=false


cilium status --wait