# ITP4121-TerrafromAssignment

Note: deploy the infrastructure first(the project root) before deploying the SimpleApplication. The kubernates provider will crash when the cluster is not present.

To deploy infrastructure individully, use the following steps

```sh
terraform apply -target=module.aws-eks-cluster
```