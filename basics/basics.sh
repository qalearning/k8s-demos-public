#!/bin/bash

. ../demo-magic.sh
clear

NS_NAME=default
WS_NAME=myapp

pei "# build a Dockerfile"
pe "cat ../simple-image/Dockerfile"
pe "cat ../simple-image/app/main.py | grep root -A8"

pe "sudo docker build ../simple-image/. -t myapp:v1"

pei "# and run it"
p 'cid=$(sudo docker run -d -p 80:80 myapp:v1)'
cid=$(sudo docker run -d -p 80:80 myapp:v1)
pei 'echo $cid'

pei "# and then test it"
pei "curl localhost"

pei "# ok but I have hundreds of containers to run and scale and manage and secure &c"
pei 'sudo docker stop $cid'

pei "# make sure it's gone..."
pei "curl localhost"

pei "# a pod is a wrapper for containers"
pe "cat ../simple-image/app_pod.yaml"
pei "# lots of ways to create a pod but we'll APPLY a file.."
pe "kubectl apply -f ../simple-image/app_pod.yaml"

pei "# and test it"
pei "curl localhost"
pe "# huh?"
pei "curl myapp"
pei "# shame, would have been nice..."

pei "# we need to EXPOSE the app"
pe "kubectl expose pod myapp --type=NodePort"
pe "kubectl get svc myapp"

PORT_NUMBER=$(kubectl -n $NS_NAME get svc $WS_NAME -o=custom-columns=ip:.spec.ports[0].nodePort --no-headers)
pe "curl -s localhost:$PORT_NUMBER"
pei "# sorted! Now let's DEPLOY it"

pei "kubectl delete svc myapp"
pei "kubectl delete pod myapp"


pe "head ../simple-image/app_deploy.yaml -n 22"
pe "kubectl apply -f ../simple-image/app_deploy.yaml"
pei "# note I'm exposing a Deployment this time."
pe "kubectl expose deployment myapp --type=NodePort"

pe "kubectl get svc myapp"

PORT_NUMBER=$(kubectl -n $NS_NAME get svc $WS_NAME -o=custom-columns=ip:.spec.ports[0].nodePort --no-headers)
pe "curl -s localhost:$PORT_NUMBER"

pei "# now I can SCALE it (I could also change the yaml and update the deployment)"
pe "kubectl scale deploy myapp --replicas=5"

for n in 1 1 1 1 1 1 1 1 1 1 1 1 1 1
do
    pei "curl -s localhost:$PORT_NUMBER"
done

if $1 = "-e"
    pei "# let's roll out v2 (it adds 'version: 2' to the output...)"
    pe "sudo docker build ../simple-image/. -f ../simple-image/Dockerfile_v2 -t myapp:v2"
    pei "head ../simple-image/app_deploy_v2.yaml -n 22"
    pe "kubectl apply -f ../simple-image/app_deploy_v2.yaml"

    for n in 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    do
        pei "curl -s localhost:$PORT_NUMBER"
    done
fi

pei "# cleanup"
pei "kubectl delete svc myapp"
pei "kubectl delete deploy myapp"

