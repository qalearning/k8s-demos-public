#!/bin/bash

. ../demo-magic.sh
clear

WS_NAME=httpd
C_NAME=curl
TIMEOUT=5
WS_IMAGE="httpd"
NS_NAME=demo

pei "# NodePort vs ClusterIP"
pe "kubectl create namespace $NS_NAME"

pe "kubectl --namespace $NS_NAME run $WS_NAME --image=$WS_IMAGE --port=80"

pei "kubectl wait --for=condition=ready pod $WS_NAME --namespace $NS_NAME"

pei "# Get the pod's IP..."

p 'podIP=$(kubectl -n '"$NS_NAME"' get po'" $WS_NAME -o=custom-columns=ip:.status.podIP --no-headers)"
podIP=$(kubectl -n $NS_NAME get po $WS_NAME -o=custom-columns=ip:.status.podIP --no-headers)

p 'echo $podIP'
echo $podIP
p 'curl $podIP --connect-timeout '"$TIMEOUT"
curl $podIP --connect-timeout $TIMEOUT

pe "kubectl -n $NS_NAME exec $WS_NAME -- curl -s localhost"

pei "# Let's try from another pod"

pe "kubectl -n $NS_NAME run $C_NAME --image=curlimages/curl --command -- sh -c 'sleep 1d'"

pei "kubectl wait --for=condition=ready pod $C_NAME --namespace $NS_NAME"

p "kubectl -n $NS_NAME exec $C_NAME"' -- curl -s $podIP --connect-timeout'" $TIMEOUT"
kubectl -n $NS_NAME exec $C_NAME -- curl -s $podIP --connect-timeout $TIMEOUT

pei "# What if I didn't know the Pod's IP? And who wants to use IP addresses anyway?!"

pe "kubectl -n $NS_NAME expose pod $WS_NAME"

pe "kubectl -n $NS_NAME get svc,ep"

pe "kubectl -n $NS_NAME exec $C_NAME -- curl -s $WS_NAME"

pei "# But I still can't get to it from outside the cluster..."

pe "curl -s $WS_NAME --connect-timeout $TIMEOUT"

pei "# So let's ditch that ClusterIP service..."

pe "kubectl -n $NS_NAME delete svc $WS_NAME"

pei "# and replace it with a NodePort"

pe "kubectl -n $NS_NAME expose pod $WS_NAME --type=NodePort"

pe "kubectl -n $NS_NAME get svc,ep"

PORT_NUMBER=$(kubectl -n $NS_NAME get svc $WS_NAME -o=custom-columns=ip:.spec.ports[0].nodePort --no-headers)

pe "curl -s localhost:$PORT_NUMBER"

pe "kubectl -n $NS_NAME exec $C_NAME -- curl -s $WS_NAME"

pe "# Cleanup"

pei "kubectl delete namespace $NS_NAME"
