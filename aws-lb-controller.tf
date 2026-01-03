################################################################################
# AWS Load Balancer Controller
# https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller
################################################################################

# IAM Role for AWS Load Balancer Controller (IRSA)
resource "aws_iam_role" "aws_lb_controller" {
  name                 = "${var.cluster_name}-aws-lb-controller"
  permissions_boundary = var.iam_role_permissions_boundary
  assume_role_policy   = data.aws_iam_policy_document.aws_lb_controller_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy" "aws_lb_controller" {
  name   = "${var.cluster_name}-aws-lb-controller"
  role   = aws_iam_role.aws_lb_controller.id
  policy = data.aws_iam_policy_document.aws_lb_controller.json
}

# Helm Release for AWS Load Balancer Controller
resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.aws_lb_controller_version
  namespace  = local.kube_system_namespace

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = var.region
      vpcId       = var.vpc_id
      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.aws_lb_controller.arn
        }
      }
      replicaCount = 2
    })
  ]

  depends_on = [aws_iam_role_policy.aws_lb_controller]
}
