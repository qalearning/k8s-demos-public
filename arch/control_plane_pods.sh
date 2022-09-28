#!/bin/bash

. ../demo-magic.sh
clear

NS_NAME=demos

# really need to be running `k1s.py -n kube-system` or similar for this

# on docker desktop, in order to find the manifests, you need to connect to the VM:
# docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh
# and then you can ls /etc/kubernetes/manifests
pei "sudo systemctl status kubelet"

pei "kubectl get pod --namespace kube-system"
pei "ls /etc/kubernetes/manifests"
pei "# static pods are suffixed with node-name"
pe 'NODE=$(kubectl get node -l node-role.kubernetes.io/master= -o name | cut -d"/" -f 2)'
pei 'echo $NODE'
pei 'kubectl -n kube-system delete pod etcd-$NODE'
pei "kubectl get pod --namespace kube-system"
pei "kubectl get pod --namespace kube-system"

pei 'kubectl -n kube-system delete pod kube-apiserver-$NODE'
pei "kubectl get pod --namespace kube-system"

#pei "sudo cp ../simple-image/app_pod.yaml /etc/kubernetes/manifests"
#pei "kubectl get pod --namespace kube-system"
# on docker desktop (WiP):
# docker run -d --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh -c 'sleep 1d'
# docker cp ../simple-image/app_pod.yaml container-id:/etc/kubernetes/manifests/