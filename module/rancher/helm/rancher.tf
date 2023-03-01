resource "null_resource" "rancher_namespace" {
  provisioner "local-exec" {
    command = "kubectl create namespace cattle-system --kubeconfig=kubeconfig.yml"
  }
}
resource "time_sleep" "wait_30_seconds" {
/*   depends_on = [ helm_release.helm_cert_manager,
    helm_release.nginx_ingress] */

  create_duration = "50s"
}
#install rancher
resource "helm_release" "rancher" {
  depends_on = [
    null_resource.rancher_namespace,
    time_sleep.wait_30_seconds
  ]
  name      = "rancher"
  chart     = var.rancher_chart

  namespace = "cattle-system"

  set {
    name  = "hostname"
    value = var.hostname
  }

  set {
    name = "replicas"
    value = 3
  }
}
resource "null_resource" "roullout-rancher" {
  depends_on = [
    helm_release.rancher
  ]
  provisioner "local-exec" {
    command = "kubectl -n cattle-system rollout status deploy/rancher --kubeconfig=kubeconfig.yml"
  }
}