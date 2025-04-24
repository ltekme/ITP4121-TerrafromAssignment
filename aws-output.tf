output "aws-rds-instance-endpoint" {
  value = module.aws-eks-cluster.rds-instance-endpoint
}
output "aws-rds-instance-username" {
  value = module.aws-eks-cluster.rds-instance-username
}
output "aws-rds-instance-password" {
  value = module.aws-eks-cluster.rds-instance-password
}
output "aws-eks-cluster-name" {
  value = module.aws-eks-cluster.eks-cluster-name
}
output "aws-eks-cluster-endpoint" {
  value = module.aws-eks-cluster.eks-cluster-endpoint
}
