# oc-terraform-module-essential-addons

Terraform module for deploying essential EKS addons using official Helm releases and AWS EKS addons.

## Addons Included

| Addon | Description | Deployment Method |
|-------|-------------|-------------------|
| **Cluster Autoscaler** | Auto-scales node groups based on pending pods | Helm |
| **VPC CNI** | AWS-native CNI for pod networking with prefix delegation | Helm |
| **CoreDNS** | Kubernetes DNS service | Helm |
| **AWS Load Balancer Controller** | Manages ALB/NLB for Kubernetes services | Helm |
| **Metrics Server** | Resource metrics for HPA/VPA | Helm |
| **EKS Pod Identity Agent** | Simplified IAM permissions for pods | EKS Addon |

## Prerequisites

- Existing EKS cluster with OIDC provider enabled
- Terraform >= 1.5.0
- AWS Provider >= 6.15.0
- Helm Provider >= 2.17.0
- Kubernetes Provider >= 2.35.0

## Usage

```hcl
module "essential_addons" {
  source = "git::https://github.com/orbitcluster/oc-terraform-module-essential-addons.git?ref=main"

  # Cluster connection
  cluster_name                       = module.eks.cluster_name
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  cluster_oidc_provider_arn          = module.eks.oidc_provider_arn
  cluster_oidc_issuer_url            = module.eks.oidc_issuer_url

  # Networking
  vpc_id = module.networking.vpc_id
  region = "us-east-1"

  # Optional: Toggle addons (all enabled by default)
  enable_cluster_autoscaler  = true
  enable_vpc_cni             = true
  enable_coredns             = true
  enable_aws_lb_controller   = true
  enable_metrics_server      = true
  enable_pod_identity_agent  = true

  # Optional: Version overrides
  # cluster_autoscaler_version = "9.43.2"
  # vpc_cni_version            = "1.19.0"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Provider Configuration

The calling module must configure the Helm and Kubernetes providers:

```hcl
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| cluster_endpoint | Endpoint URL of the EKS cluster API server | `string` | n/a | yes |
| cluster_certificate_authority_data | Base64 encoded certificate authority data | `string` | n/a | yes |
| cluster_oidc_provider_arn | ARN of the OIDC provider for IRSA | `string` | n/a | yes |
| cluster_oidc_issuer_url | URL of the OIDC issuer | `string` | n/a | yes |
| vpc_id | VPC ID where the EKS cluster is deployed | `string` | n/a | yes |
| region | AWS region | `string` | n/a | yes |
| enable_cluster_autoscaler | Enable Cluster Autoscaler | `bool` | `true` | no |
| enable_vpc_cni | Enable VPC CNI | `bool` | `true` | no |
| enable_coredns | Enable CoreDNS | `bool` | `true` | no |
| enable_aws_lb_controller | Enable AWS Load Balancer Controller | `bool` | `true` | no |
| enable_metrics_server | Enable Metrics Server | `bool` | `true` | no |
| enable_pod_identity_agent | Enable Pod Identity Agent | `bool` | `true` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |
| iam_role_permissions_boundary | ARN of permissions boundary for IAM roles | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_autoscaler_iam_role_arn | ARN of the Cluster Autoscaler IAM role |
| vpc_cni_iam_role_arn | ARN of the VPC CNI IAM role |
| aws_lb_controller_iam_role_arn | ARN of the AWS LB Controller IAM role |
| cluster_autoscaler_release_name | Name of the Cluster Autoscaler Helm release |
| vpc_cni_release_name | Name of the VPC CNI Helm release |
| coredns_release_name | Name of the CoreDNS Helm release |
| aws_lb_controller_release_name | Name of the AWS LB Controller Helm release |
| metrics_server_release_name | Name of the Metrics Server Helm release |
| pod_identity_agent_addon_version | Version of the Pod Identity Agent addon |

## IRSA (IAM Roles for Service Accounts)

This module automatically creates IRSA roles for addons that require AWS API access:
- **Cluster Autoscaler**: Permissions to manage Auto Scaling Groups
- **VPC CNI**: AmazonEKS_CNI_Policy
- **AWS Load Balancer Controller**: Comprehensive ELB/EC2 permissions

## License

Apache 2.0 License
