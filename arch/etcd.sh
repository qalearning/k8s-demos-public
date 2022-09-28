#!/bin/bash

. ../demo-magic.sh
clear

NS_NAME=demos

pe 'NODE=$(kubectl get node -l node-role.kubernetes.io/master= -o name | cut -d"/" -f 2)'

pe 'kubectl -n kube-system exec -it etcd-$NODE -- sh \
  -c "ETCDCTL_API=3 \
  ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt \
  ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt \
  ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key \
  etcdctl get / --prefix --keys-only"'

pe 'kubectl -n kube-system exec -it etcd-$NODE -- sh \
  -c "ETCDCTL_API=3 \
  ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt \
  ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt \
  ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key \
  etcdctl get /registry/pods/kube-system/calico-node-g5tfm"'