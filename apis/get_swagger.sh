#!/bin/bash -xe

kubectl proxy --port=8080 &

sleep 10

curl localhost:8080/openapi/v2 > k8s-swagger.json
# from https://jonnylangefeld.com/blog/kubernetes-how-to-view-swagger-ui
