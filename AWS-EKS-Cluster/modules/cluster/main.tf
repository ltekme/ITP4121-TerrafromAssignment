
resource "aws_eks_cluster" "main" {
  name = var.name
  access_config {
    authentication_mode = "API"
  }

  role_arn = var.role-arn
  version  = "1.32"

  vpc_config {
    subnet_ids = var.subnet-ids
  }
}


resource "aws_eks_node_group" "main-grp" {
  cluster_name = aws_eks_cluster.main.name

  node_group_name = "${aws_eks_cluster.main.name}-1"
  node_role_arn   = var.node-role-arn
  subnet_ids      = var.node-subnet-ids

  capacity_type = "SPOT"

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

}

data "aws_eks_cluster_auth" "token" {
  name = aws_eks_cluster.main.name
}

/*########################################################
IMPORTANT!!!

Need to do this manually as the role for cluster is the same 
used to access, best practice is to have sepreate role for
each purpose, however, this is learner lab with restrictions.

########################################################*/
# resource "aws_eks_access_entry" "this" {
#   cluster_name  = aws_eks_cluster.main.name
#   principal_arn = var.cluster-access-role-arn
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "pa-admin" {
#   cluster_name  = aws_eks_cluster.main.name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
#   principal_arn = var.cluster-access-role-arn

#   access_scope {
#     type = "cluster"
#   }
# }

# resource "aws_eks_access_policy_association" "pa-cluster-admin" {
#   cluster_name  = aws_eks_cluster.main.name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#   principal_arn = var.cluster-access-role-arn

#   access_scope {
#     type = "cluster"
#   }
# }
