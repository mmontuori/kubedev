#!/bin/bash

if [ "$1" == "" ]; then
    echo "specify the port as CLI argument"
    echo "Usage: $0 <port>"
    exit 1
fi
PORT=$1

if ! minikube status | grep -q "Running"; then
    echo "Run the setup-minikube.sh script to setup a local cluster..."
    exit
fi

namespace="website"
echo "Creating a new namespace for ${namespace}..."

if `minikube kubectl create namespace ${namespace}`; then
    echo "Namespace '${namespace}' already exists."
else
    echo "Namespace '${namespace}' created successfully."
fi

echo "Creating website pod..."
minikube kubectl -- apply -f deployment/nginx-web-site.yaml

echo "waiging for containers to start..."
while ! minikube kubectl -- get pods --namespace=${namespace} | grep website | grep Running; do
    sleep 5
done

minikube kubectl -- port-forward --namespace=${namespace} --address=0.0.0.0 service/website ${PORT}:80