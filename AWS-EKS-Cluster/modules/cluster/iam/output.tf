output "cluster-role" {
  value = aws_iam_role.cluster-role
}

output "cluster-node-role" {
  value = aws_iam_role.cluster-node-role
}
