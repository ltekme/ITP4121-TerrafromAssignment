
resource "aws_eks_cluster" "main" {
  name = var.name
  access_config {
    authentication_mode = "API"
  }

  role_arn = var.role-arn
  version  = "1.31"

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
