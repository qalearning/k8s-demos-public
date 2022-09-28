#!/bin/bash

. ../demo-magic.sh
clear

p "# create a pod"
pei "kubectl run app --image busybox -- /bin/sh -c 'i=0; while true; do echo "'"$i: $(date)"''; i=$((i+1))'"; sleep 5; done'"
pei "kubectl wait --for=condition=ready pod app"


pei "#via kubectl"
pei "kubectl logs app"

pei "# connect from outside the cluster"
pei "# first, get the keys and certs"
pei 'export client=$(grep client-cert $HOME/.kube/config |cut -d" " -f 6)'
pei 'export key=$(grep client-key-data $HOME/.kube/config |cut -d" " -f 6)'
pei 'export auth=$(grep certificate-authority-data $HOME/.kube/config |cut -d" " -f 6)'

pei "# then save them somewhere"
pei 'echo $client | base64 -d - > ./client.pem'
pei 'echo $key | base64 -d - > ./client-key.pem'
pei 'echo $auth | base64 -d - > ./ca.pem'

pei "# then use them"
pe 'curl --cert ./client.pem --key ./client-key.pem \
    --cacert ./ca.pem -v -XGET \
    https://k8scp:6443/api/v1/namespaces/default/pods/app/log'

# pe "kubectl proxy &"
# pei "# kubectl proxy is running, skip the creds"
# pe "curl localhost:8001/api/v1/namespaces/default/pods/app/log"

pei "# from a pod running in the cluster (with permissions)"
pe "kubectl run curl --image=curlimages/curl --command -- sh -c 'sleep 1d'"
pei "kubectl wait --for=condition=ready pod curl"

pe "kubectl exec curl -- /bin/sh -c "' \
    '"'"'token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)'" &&"' \
    curl -k https://kubernetes/api/v1/namespaces/default/pods/app/log \
    -H "''Authorization: Bearer $token"'"'"

pei "kubectl delete pod app curl --force"
rm ./ca.pem
rm ./client-key.pem
rm ./client.pem