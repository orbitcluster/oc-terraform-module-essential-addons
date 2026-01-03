################################################################################
# Cluster Autoscaler Outputs
################################################################################

output "cluster_autoscaler_iam_role_arn" {
  description = "ARN of the IAM role for Cluster Autoscaler"
  value       = var.enable_cluster_autoscaler ? aws_iam_role.cluster_autoscaler[0].arn : null
}

output "cluster_autoscaler_release_name" {
  description = "Name of the Cluster Autoscaler Helm release"
  value       = var.enable_cluster_autoscaler ? helm_release.cluster_autoscaler[0].name : null
}

################################################################################
# VPC CNI Outputs
################################################################################

output "vpc_cni_iam_role_arn" {
  description = "ARN of the IAM role for VPC CNI"
  value       = var.enable_vpc_cni ? aws_iam_role.vpc_cni[0].arn : null
}

output "vpc_cni_release_name" {
  description = "Name of the VPC CNI Helm release"
  value       = var.enable_vpc_cni ? helm_release.vpc_cni[0].name : null
}

################################################################################
# CoreDNS Outputs
################################################################################

output "coredns_release_name" {
  description = "Name of the CoreDNS Helm release"
  value       = var.enable_coredns ? helm_release.coredns[0].name : null
}

################################################################################
# AWS Load Balancer Controller Outputs
################################################################################

output "aws_lb_controller_iam_role_arn" {
  description = "ARN of the IAM role for AWS Load Balancer Controller"
  value       = var.enable_aws_lb_controller ? aws_iam_role.aws_lb_controller[0].arn : null
}

output "aws_lb_controller_release_name" {
  description = "Name of the AWS Load Balancer Controller Helm release"
  value       = var.enable_aws_lb_controller ? helm_release.aws_lb_controller[0].name : null
}

################################################################################
# Metrics Server Outputs
################################################################################

output "metrics_server_release_name" {
  description = "Name of the Metrics Server Helm release"
  value       = var.enable_metrics_server ? helm_release.metrics_server[0].name : null
}

################################################################################
# Pod Identity Agent Outputs
################################################################################

output "pod_identity_agent_addon_version" {
  description = "Version of the EKS Pod Identity Agent addon"
  value       = var.enable_pod_identity_agent ? aws_eks_addon.pod_identity_agent[0].addon_version : null
}
