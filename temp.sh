Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:


export USER_HOME="/home/ec2-user"

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join 3.17.116.249:6443 --token ifbylf.wqvn20r446v0w9ja \
	--discovery-token-ca-cert-hash sha256:46a3cac5e7dbd74efb615a1dcfb9f55abe1f2f7ca888a5ee4b5a2c6179f5fad1 \
	--control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 3.17.116.249:6443 --token ifbylf.wqvn20r446v0w9ja \
	--discovery-token-ca-cert-hash sha256:46a3cac5e7dbd74efb615a1dcfb9f55abe1f2f7ca888a5ee4b5a2c6179f5fad1