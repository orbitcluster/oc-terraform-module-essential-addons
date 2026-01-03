
run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "plan" {
  command = plan

  variables {
    cluster_name                       = run.setup.cluster_name
    cluster_endpoint                   = run.setup.cluster_endpoint
    cluster_certificate_authority_data = run.setup.cluster_certificate_authority_data
    cluster_oidc_provider_arn          = run.setup.cluster_oidc_provider_arn
    cluster_oidc_issuer_url            = run.setup.cluster_oidc_issuer_url
    vpc_id                             = run.setup.vpc_id
    region                             = run.setup.region

    # Enable all addons
    enable_cluster_autoscaler  = true
    enable_vpc_cni             = true
    enable_coredns             = true
    enable_aws_lb_controller   = true
    enable_metrics_server      = true
    enable_pod_identity_agent  = true
  }

  # Verify Cluster Autoscaler IAM role is created
  assert {
    condition     = aws_iam_role.cluster_autoscaler[0].name == "test-cluster-cluster-autoscaler"
    error_message = "Cluster Autoscaler IAM role name did not match expected value"
  }

  # Verify VPC CNI IAM role is created
  assert {
    condition     = aws_iam_role.vpc_cni[0].name == "test-cluster-vpc-cni"
    error_message = "VPC CNI IAM role name did not match expected value"
  }

  # Verify AWS LB Controller IAM role is created
  assert {
    condition     = aws_iam_role.aws_lb_controller[0].name == "test-cluster-aws-lb-controller"
    error_message = "AWS LB Controller IAM role name did not match expected value"
  }
}

run "plan_disabled_addons" {
  command = plan

  variables {
    cluster_name                       = run.setup.cluster_name
    cluster_endpoint                   = run.setup.cluster_endpoint
    cluster_certificate_authority_data = run.setup.cluster_certificate_authority_data
    cluster_oidc_provider_arn          = run.setup.cluster_oidc_provider_arn
    cluster_oidc_issuer_url            = run.setup.cluster_oidc_issuer_url
    vpc_id                             = run.setup.vpc_id
    region                             = run.setup.region

    # Disable all addons
    enable_cluster_autoscaler  = false
    enable_vpc_cni             = false
    enable_coredns             = false
    enable_aws_lb_controller   = false
    enable_metrics_server      = false
    enable_pod_identity_agent  = false
  }

  # Verify no resources are created when addons are disabled
  assert {
    condition     = length(aws_iam_role.cluster_autoscaler) == 0
    error_message = "Cluster Autoscaler IAM role should not be created when disabled"
  }

  assert {
    condition     = length(aws_iam_role.vpc_cni) == 0
    error_message = "VPC CNI IAM role should not be created when disabled"
  }
}
