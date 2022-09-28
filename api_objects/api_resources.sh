#!/bin/bash

. ../demo-magic.sh
clear

# requires jq

pe "kubectl api-resources"

pe "kubectl api-resources --namespaced"

pe "kubectl api-resources --namespaced=false"

pe "kubectl api-resources -o wide"

pe "kubectl api-resources --verbs=list -o wide"

pe "kubectl api-resources --api-group= # 'core API group'"

pe "kubectl api-resources --api-group=storage.k8s.io"

pe "kubectl api-resources --api-group=rbac.authorization.k8s.io"

pe "kubectl api-resources --api-group=apps"

pe "kubectl api-versions"

pe "kubectl proxy &"

pe "curl localhost:8001/apis/storage.k8s.io/v1beta1 | jq .resources[].name"

pe "curl localhost:8001/apis/storage.k8s.io/v1 | jq .resources[].name"