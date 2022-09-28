#!/bin/bash

. ../demo-magic.sh
clear

NS=qa-demo

pe "kubectl get pods"
pe "kubectl get pods --all-namespaces"
pe "kubectl get po -A"

pe "kubectl get namespaces"
pe "kubectl create namespace $NS"
pe "kubectl describe ns $NS"
pe "kubectl get ns/$NS -o yaml"
pe "kubectl create deploy nginx --image=nginx --replicas=5 -n $NS"
pe "kubectl expose deploy nginx --port=80 -n $NS"
pe "kubectl get deploy,svc -A"
pe "kubectl delete ns/$NS"
pe "kubectl get deploy,svc -A"
