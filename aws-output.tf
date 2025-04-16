output "aws-rds-instance-endpoint" {
  value = module.aws-eks-cluster[0].rds-instance-endpoint
}
output "aws-rds-instance-username" {
  value = module.aws-eks-cluster[0].rds-instance-username
}
output "aws-rds-instance-password" {
  value = module.aws-eks-cluster[0].rds-instance-password
}
output "aws-eks-cluster-name" {
  value = module.aws-eks-cluster[0].eks-cluster-name
}
output "aws-eks-cluster-endpoint" {
  value = module.aws-eks-cluster[0].eks-cluster-endpoint
}
output "aws-eks-cluster-certificate" {
  value = module.aws-eks-cluster[0].eks-cluster-certificate
}
output "aws-eks-cluster-auth-token" {
  value = module.aws-eks-cluster[0].eks-cluster-auth-token
}
