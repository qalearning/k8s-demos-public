#!/bin/bash

. ../demo-magic.sh
clear

WS_IMAGE="nginx:1.19.6"

pe "kubectl run nginx --image $WS_IMAGE"

pe "kubectl get pod nginx -o yaml | grep resourceVersion"