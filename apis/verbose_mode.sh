#!/bin/bash

. ../demo-magic.sh
clear

WS_IMAGE="nginx:1.19.6"

pe "kubectl run nginx --image $WS_IMAGE --v=10"

pe "kubectl get pod nginx --v=1"
pe "kubectl get pod nginx --v=2"
pe "kubectl get pod nginx --v=3"
pe "kubectl get pod nginx --v=4"
pe "kubectl get pod nginx --v=5"
pe "kubectl get pod nginx --v=6"
pe "kubectl get pod nginx --v=7"
pe "kubectl get pod nginx --v=8"
pe "kubectl get pod nginx --v=9"
pe "kubectl get pod nginx --v=10"

pe "kubectl delete pod nginx --v=10"
