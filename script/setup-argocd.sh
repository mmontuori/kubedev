#!/bin/bash

minikube kubectl -- create ns argocd

minikube kubectl -- apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.5.8/manifests/install.yaml

echo "waiting for pods to start..."

while minikube kubectl -- get pods -n argocd | awk '{ print $3 }' | grep -v STATUS | grep -v Running > /dev/null; do
    sleep 5
done

argocd_password=`minikube kubectl -- -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

echo "ArgoCD Password: ${argocd_password}"

minikube kubectl -- port-forward svc/argocd-server --address=0.0.0.0 -n argocd 8443:443 &