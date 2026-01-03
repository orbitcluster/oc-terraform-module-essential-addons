################################################################################
# Metrics Server
# https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server
################################################################################

# Helm Release for Metrics Server
resource "helm_release" "metrics_server" {
  count = var.enable_metrics_server ? 1 : 0

  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = var.metrics_server_version
  namespace  = local.kube_system_namespace

  values = [
    yamlencode({
      replicas = 2
      serviceAccount = {
        create = true
        name   = "metrics-server"
      }
      resources = {
        limits = {
          cpu    = "100m"
          memory = "200Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "200Mi"
        }
      }
      args = [
        "--kubelet-preferred-address-types=InternalIP",
        "--kubelet-use-node-status-port",
        "--metric-resolution=15s"
      ]
    })
  ]
}
