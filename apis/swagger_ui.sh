#!/bin/bash -xe
sudo docker run --rm \
    -p 80:8080 \
    -e SWAGGER_JSON=/k8s-swagger.json \
    -v $(pwd)/k8s-swagger.json:/k8s-swagger.json \
    swaggerapi/swagger-ui

# from https://jonnylangefeld.com/blog/kubernetes-how-to-view-swagger-ui
