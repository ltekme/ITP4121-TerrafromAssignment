## Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

## Install Terraform
https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli

az login

terraform plan
terraform apply --auto-approve
export KUBECONFIG=./kubeconfig
kubectl apply -f xxxxxxx.yaml
kubectl get service store-front --watch

terraform init -upgrade