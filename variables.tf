################CLUSTER INFO######################

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint URL of the EKS cluster API server"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate authority data for the cluster"
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "ARN of the OIDC provider for IRSA (IAM Roles for Service Accounts)"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "URL of the OIDC issuer for the EKS cluster"
  type        = string
}

##################################################

################ADDON TOGGLES#####################

variable "enable_cluster_autoscaler" {
  description = "Enable Cluster Autoscaler addon"
  type        = bool
  default     = true
}

variable "enable_vpc_cni" {
  description = "Enable AWS VPC CNI addon"
  type        = bool
  default     = true
}

variable "enable_coredns" {
  description = "Enable CoreDNS addon"
  type        = bool
  default     = true
}

variable "enable_aws_lb_controller" {
  description = "Enable AWS Load Balancer Controller addon"
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "Enable Metrics Server addon"
  type        = bool
  default     = true
}

variable "enable_pod_identity_agent" {
  description = "Enable EKS Pod Identity Agent addon"
  type        = bool
  default     = true
}

##################################################

################ADDON VERSIONS####################

variable "cluster_autoscaler_version" {
  description = "Version of the Cluster Autoscaler Helm chart"
  type        = string
  default     = "9.43.2"
}

variable "vpc_cni_version" {
  description = "Version of the AWS VPC CNI Helm chart"
  type        = string
  default     = "1.19.0"
}

variable "coredns_version" {
  description = "Version of the CoreDNS Helm chart"
  type        = string
  default     = "1.36.2"
}

variable "aws_lb_controller_version" {
  description = "Version of the AWS Load Balancer Controller Helm chart"
  type        = string
  default     = "1.11.0"
}

variable "metrics_server_version" {
  description = "Version of the Metrics Server Helm chart"
  type        = string
  default     = "3.12.2"
}

variable "pod_identity_agent_version" {
  description = "Version of the EKS Pod Identity Agent addon"
  type        = string
  default     = null
}

##################################################

################NETWORKING INFO###################

variable "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  type        = string
}

variable "region" {
  description = "AWS region where the EKS cluster is deployed"
  type        = string
}

##################################################

################COMMON CONFIG#####################

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the permissions boundary to attach to IAM roles"
  type        = string
  default     = null
}

##################################################
