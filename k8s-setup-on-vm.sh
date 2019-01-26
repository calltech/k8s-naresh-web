#!/bin/bash

# these commands will setup docker on any VM e.g. AWS VM or Google cloud VM.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu
sudo apt-mark hold docker-ce



# Verify that Docker is up and running with:
#sudo systemctl status docker
# Install Kubeadm, Kubelet, and Kubectl on all  nodes.
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet=1.12.2-00 kubeadm=1.12.2-00 kubectl=1.12.2-00
sudo apt-mark hold kubelet kubeadm kubectl



# Bootstrap the cluster on the Kube master node.
sudo kubeadm init --pod-network-cidr=10.244.0.0/16



# Setting up local kubeconfig
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Join the two Kube worker nodes to the cluster.
#Take note that the kubeadm init command printed a long kubeadm join command to the screen. You will need that kubeadm join command in the next step!

sudo kubeadm join $some_ip:6443 --token $some_token --discovery-token-ca-cert-hash $some_hash

# 2. Now, on the Kube master node, make sure your nodes joined the cluster successfully:

kubectl get nodes

# Note that the nodes are expected to be in the NotReady state for now.

# Set up cluster networking with flannel.
# 1. Turn on iptables bridge calls on all  nodes including master and worker nodes:
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# 2. Next, run this only on the Kube master node:
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml

# Now flannel is installed! Make sure it is working by checking the node status again:

kubectl get nodes

