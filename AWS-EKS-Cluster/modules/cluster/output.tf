output "cluster-auth-token" {
  value = data.aws_eks_cluster_auth.token
}
output "cluster" {
  value = aws_eks_cluster.main
}
