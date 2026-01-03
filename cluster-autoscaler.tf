################################################################################
# Cluster Autoscaler
# https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler
################################################################################

# IAM Role for Cluster Autoscaler (IRSA)
resource "aws_iam_role" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  name                 = "${var.cluster_name}-cluster-autoscaler"
  permissions_boundary = var.iam_role_permissions_boundary
  assume_role_policy   = data.aws_iam_policy_document.cluster_autoscaler_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  name   = "${var.cluster_name}-cluster-autoscaler"
  role   = aws_iam_role.cluster_autoscaler[0].id
  policy = data.aws_iam_policy_document.cluster_autoscaler.json
}

# Helm Release for Cluster Autoscaler
resource "helm_release" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.cluster_autoscaler_version
  namespace  = local.kube_system_namespace

  values = [
    yamlencode({
      autoDiscovery = {
        clusterName = var.cluster_name
      }
      awsRegion = var.region
      rbac = {
        serviceAccount = {
          create = true
          name   = "cluster-autoscaler"
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler[0].arn
          }
        }
      }
      extraArgs = {
        balance-similar-node-groups  = true
        skip-nodes-with-system-pods  = false
      }
    })
  ]

  depends_on = [aws_iam_role_policy.cluster_autoscaler]
}
