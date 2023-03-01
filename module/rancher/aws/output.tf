
output "eks_cluster" {
  value = aws_eks_cluster.eks
}

output "eks_endpint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cert" {
  value = aws_eks_cluster.eks.certificate_authority
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}