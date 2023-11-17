#!/bin/bash

. ../demo-magic.sh
clear

export NS=demo

pe "kubectl create namespace $NS"

pe "kubectl -n $NS apply -f depv1.yaml"

pe "kubectl -n $NS set image deployments.app/simple-app simple-app=danielives/simple-app:v2"
pei "kubectl -n $NS rollout pause deployments.app/simple-app"

pe "kubectl -n $NS rollout resume deployments.app/simple-app"

pe "kubectl -n $NS rollout history deployments.app/simple-app"

pe "kubectl -n $NS set image deployments.app/simple-app simple-app=danielives/simple-app:v3 --record"

pe "kubectl -n $NS rollout history deployments.app/simple-app"

pe "kubectl -n $NS edit deploy simple-app --record"

pe "kubectl -n $NS rollout history deployments.app/simple-app"

pe "kubectl -n $NS rollout undo deployment simple-app --to-revision=2"