resource "aws_iam_role" "cluster-role" {
  name = "cluster-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "eks.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy" "cluster-role" {
  name        = "cluster-node-policy"
  description = "policy for cluster role"
  policy      = file("${path.module}/policy-documents/cluster.json")

}

resource "aws_iam_role_policy_attachment" "cluster-role" {
  role       = aws_iam_role.cluster-role.name
  policy_arn = aws_iam_policy.cluster-role.arn
}

resource "aws_iam_role" "cluster-node-role" {
  name = "cluster-node-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "sts:AssumeRole"
        ],
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com",
          ]
        }
      }
    ]
  })
}

# resource "aws_iam_policy" "cluster-node-role" {
#   name        = "cluster-node-role-policy"
#   description = "policy for node role"
#   policy      = file("${path.module}/policy-documents/node.json")
# }

resource "aws_iam_role_policy_attachment" "cluster-node-role-node-policy" {
  role       = aws_iam_role.cluster-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cluster-node-role-cni-policy" {
  role       = aws_iam_role.cluster-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "cluster-node-role-ecr-policy" {
  role       = aws_iam_role.cluster-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
