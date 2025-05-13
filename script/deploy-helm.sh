#!/bin/bash

if [ "$1" == "" ]; then
    echo "specify the port as CLI argument"
    echo "Usage: $0 <appname> <namespace> <helm directory> <port>"
    exit 1
fi

appname="$1"
namespace="$2"
helmdir="$3"
port="$4"

helm install ${appname} --namespace ${namespace} --create-namespace ${helmdir}

echo "waiging for containers to start..."
while minikube kubectl -- get pods -n ${namespace} | awk '{ print $3 }' | grep -v STATUS | grep -v Running > /dev/null; do
    sleep 5
done

echo "running: minikube kubectl -- port-forward --namespace=${namespace} --address=0.0.0.0 service/${appname} ${port}:80"
minikube kubectl -- port-forward --namespace=${namespace} --address=0.0.0.0 service/${appname} ${port}:80