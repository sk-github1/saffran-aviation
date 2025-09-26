# Minimal IAM role for EKS cluster (this is a starting point — tighten permissions for prod)
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  tags = { Name = "${var.project}-eks-cluster-role" }
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]

    }
  }
}
