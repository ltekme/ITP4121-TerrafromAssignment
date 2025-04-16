#!/bin/bash

terraform init -upgrade

terraform plan

terraform apply --auto-approve

export KUBECONFIG=./kubeconfig

kubectl apply -f azure-vote.yaml

kubectl get service azure-vote-front --watch