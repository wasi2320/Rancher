resource "null_resource" "nginx_namespace" {
  provisioner "local-exec" {
    command = "kubectl create namespace ingress-nginx --kubeconfig=kubeconfig.yml"
  }
}
resource "helm_release" "nginx_ingress" {
  depends_on = [
    null_resource.nginx_namespace
  ]
 name        = "nginx"
  repository  = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  namespace   = "ingress-nginx"
  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
} 