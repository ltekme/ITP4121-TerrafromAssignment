output "rds-instance-endpoint" {
  value = module.database.rds-instance.endpoint
}
output "rds-instance-username" {
  value = local.rds-master-username
}
output "rds-instance-password" {
  value = local.rds-master-password
}
output "eks-cluster-name" {
  value = module.eks-cluster.cluster.name
}
output "eks-cluster-endpoint" {
  value = module.eks-cluster.cluster.endpoint
}
output "eks-cluster-certificate" {
  value = base64decode(module.eks-cluster.cluster.certificate_authority[0].data)
}
output "eks-cluster-auth-token" {
  value = module.eks-cluster.cluster-auth-token
}
