#!/bin/bash

. ../demo-magic.sh
clear

NS=demo
pe "kubectl create ns $NS"

pe 'kubectl -n '$NS' run app --image busybox -- /bin/sh -c '"'"'i=0; while true; do echo $i: $(date); i=$((i+1)); sleep 5; done'"'"
# kubectl -n $NS run app --image busybox -- /bin/sh -c 'i=0; while true; do echo $i: $(date); i=$((i+1)); sleep 5; done'

pe "kubectl -n $NS run curl --image=curlimages/curl --command -- sh -c 'sleep 1d'"

pei "kubectl wait --for=condition=ready pod curl --namespace $NS"

pe "kubectl -n $NS logs app"

p 'kubectl -n '$NS' exec curl -- /bin/sh -c \\\n   '"'"'token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) && \\\n   curl -k https://kubernetes.default.svc/api/v1/namespaces/demo/pods/app/log \\\n   -H "Authorization: Bearer $token"'"'"

kubectl -n $NS exec curl -- /bin/sh -c \
    'token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) && \
    curl -k https://kubernetes.default.svc/api/v1/namespaces/demo/pods/app/log \
    -H "Authorization: Bearer $token"'

pe "less role.yaml"
pe "less rolebinding.yaml"
pe "kubectl create -f role.yaml"
pe "kubectl create -f rolebinding.yaml"

p 'kubectl -n '$NS' exec curl -- /bin/sh -c \\\n   '"'"'token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) && \\\n   curl -k https://kubernetes.default.svc/api/v1/namespaces/demo/pods/app/log \\\n   -H "Authorization: Bearer $token"'"'"

kubectl -n $NS exec curl -- /bin/sh -c \
    'token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) && \
    curl -k https://kubernetes.default.svc/api/v1/namespaces/demo/pods/app/log \
    -H "Authorization: Bearer $token"'

pe "kubectl delete ns $NS"