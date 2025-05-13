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

echo "Creating a new namespace for WordPress..."

if `minikube kubectl create namespace wordpress`; then
    echo "Namespace 'wordpress' already exists."
else
    echo "Namespace 'wordpress' created successfully."
fi

#minikube kubectl -- create secret --namespace=wordpress generic mysql-pass --from-literal password="passw0rd"
minikube kubectl -- apply -f deployment/secret-data.yaml

echo "Creating MySql pod..."
minikube kubectl -- apply -f deployment/wordpress-mysql.yaml

echo "Creating WordPress pod..."
minikube kubectl -- apply -f deployment/wordpress-web.yaml

echo "waiging for containers to start..."
while ! minikube kubectl -- get pods --namespace=wordpress | grep wordpress-web | grep Running; do
    sleep 5
done

minikube kubectl -- port-forward --namespace=wordpress --address=0.0.0.0 service/wordpress-web ${PORT}:80