#!/bin/bash
. ../demo-magic.sh
clear

pe "kubectl run demo --image=danielives/simple-app:v1 --dry-run=client -o yaml > demo.yaml"
pe "kubectl get pods"
pe "cat demo.yaml"
pe "kubectl apply -f demo.yaml"
pe "kubectl get pods"
pe 'export do="--dry-run=client -o yaml"'
pe 'kubectl create deploy demo_deploy --image=danielives/simple-app:v1 $do > demo_deploy.yaml'
pe "cat demo_deploy.yaml"
pe "kubectl delete pod demo --force"
pei "rm demo.yaml demo_deploy.yaml"