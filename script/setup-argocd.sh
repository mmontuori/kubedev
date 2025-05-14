#!/bin/bash

minikube kubectl -- create ns argocd

minikube kubectl -- apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.0.1/manifests/install.yaml

echo "waiting for pods to start..."

while minikube kubectl -- get pods -n argocd | awk '{ print $3 }' | grep -v STATUS | grep -v Running > /dev/null; do
    sleep 5
done

curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

argocd_password=`minikube kubectl -- -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

echo "ArgoCD Password: ${argocd_password}"

minikube kubectl -- port-forward svc/argocd-server --address=0.0.0.0 -n argocd 8443:443 &