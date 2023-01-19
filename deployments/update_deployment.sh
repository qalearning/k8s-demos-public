#!/bin/bash

. ../demo-magic.sh
clear

pe "kubectl set image deployments.app/simple-app simple-app=danielives/helloworld:v2"
pei "kubectl rollout pause deployments.app/simple-app"

pe "kubectl rollout resume deployments.app/simple-app"

pe "kubectl rollout history deployments.app/simple-app"

pe "kubectl set image deployments.app/simple-app simple-app=danielives/helloworld:v3 --record"

pe "kubectl rollout history deployments.app/simple-app"

pe "kubectl edit deploy simple-app --record"

pe "kubectl rollout history deployments.app/simple-app"

pe "kubectl rollout undo deployment simple-app --to-revision=2"