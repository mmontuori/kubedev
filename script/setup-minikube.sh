#!/bin/bash

if `minikube status | grep -q "Running"`; then
    echo "Minikube is already running."
    echo "delete the local cluster with 'minikube delete' if you want to start over."
else
    echo "Starting Minikube..."
    minikube start
fi

echo "Installing Helm..."
if ! command -v helm &> /dev/null
then
    echo "Helm could not be found, installing..."
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
else
    echo "Helm is already installed."
fi

echo "Installing alias command for minikube kubectl..."
if ! grep "minikube kubectl" ~/.bashrc &> /dev/null
then
    echo "Alias 'k' for kubectl could not be found, creating..."
    echo "alias k=\"minikube kubectl\"" >> ~/.bashrc
    echo "alias kubectl=\"minikube kubectl\"" >> ~/.bashrc
    echo "Logout and login again to use the alias 'k' and 'kubectl' for 'minikube kubectl'."
else
    echo "Alias 'k' for kubectl is already created."
fi