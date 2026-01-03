################################################################################
# AWS VPC CNI
# https://github.com/aws/amazon-vpc-cni-k8s/tree/master/charts/aws-vpc-cni
################################################################################

# IAM Role for VPC CNI (IRSA)
resource "aws_iam_role" "vpc_cni_role" {
  name                 = "${var.cluster_name}-vpc-cni"
  permissions_boundary = var.iam_role_permissions_boundary
  assume_role_policy   = data.aws_iam_policy_document.vpc_cni_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "vpc_cni_pa" {
  role       = aws_iam_role.vpc_cni_role.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Helm Release for VPC CNI
resource "helm_release" "vpc_cni" {
  name       = "aws-vpc-cni"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-vpc-cni"
  version    = var.vpc_cni_version
  namespace  = local.kube_system_namespace

  values = [
    yamlencode({
      init = {
        image = {
          region = var.region
        }
      }
      image = {
        region = var.region
      }
      serviceAccount = {
        create = false
        name   = "aws-node"
      }
      originalMatchLabels = true
      env = {
        ENABLE_PREFIX_DELEGATION = "true"
        WARM_PREFIX_TARGET       = "1"
      }
    })
  ]

  depends_on = [aws_iam_role_policy_attachment.vpc_cni_pa]
}

# Annotate the existing aws-node service account with IRSA role
resource "kubernetes_annotations" "vpc_cni_sa" {
  api_version = "v1"
  kind        = "ServiceAccount"

  metadata {
    name      = "aws-node"
    namespace = local.kube_system_namespace
  }

  annotations = {
    "eks.amazonaws.com/role-arn" = aws_iam_role.vpc_cni_role.arn
  }

  force = true

  depends_on = [aws_iam_role.vpc_cni_role]
}
