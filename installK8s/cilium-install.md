cilium install \
--namespace kube-system \
--set kubeProxyReplacement=strict \
--set k8sServiceHost=k8s-controller-0 \
--set k8sServicePort=6443 \
--set clusterPoolIPv4PodCIDRList=["192.168.0.0/16"]