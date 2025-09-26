# Minimal EKS cluster definition - adapt for production!
resource "aws_eks_cluster" "eks" {
  name     = "${var.project}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
  }

  # NOTE: Kubernetes version, addons, and logging configuration should be set here.
  depends_on = [aws_iam_role.eks_cluster_role]
}

# A managed node group example (requires node role & policy attachments)
resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.project}-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.public[*].id
  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }
}

resource "aws_iam_role" "eks_node_role" {
  name = "${var.project}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json
}

data "aws_iam_policy_document" "node_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
