################################################################################
# Essential Addons Module - Example Usage
################################################################################

module "essential_addons" {
  source = "../"

  # Cluster connection
  cluster_name                       = "<cluster-name>"       # Replace with your cluster name
  cluster_endpoint                   = "<cluster-endpoint>"   # Replace with cluster endpoint
  cluster_certificate_authority_data = "<ca-data>"            # Replace with CA data
  cluster_oidc_provider_arn          = "<oidc-provider-arn>"  # Replace with OIDC provider ARN
  cluster_oidc_issuer_url            = "<oidc-issuer-url>"    # Replace with OIDC issuer URL

  # Networking
  vpc_id = "<vpc-id>"     # Replace with VPC ID
  region = "us-east-1"

  # Addon toggles (all enabled by default)
  enable_cluster_autoscaler  = true
  enable_vpc_cni             = true
  enable_coredns             = true
  enable_aws_lb_controller   = true
  enable_metrics_server      = true
  enable_pod_identity_agent  = true

  tags = local.tags
}
