variable "certmanager_version" {
  type        = string
  default     = "1.10.0"
  description = "Version of cert-manager to install"
}

variable "certmanager_chart" {
  type        = string
  default     = "jetstack/cert-manager"
  description = "Helm chart to use for cert-manager install"
}

variable "rancher_chart" {
  type        = string
  default     = "rancher-stable/rancher"
  description = "Helm chart to use for Rancher install"
}


variable "hostname" {
  type    = string
  default = "ranche.iamedem.name"
}

variable "email" {
  type    = string
  default = "tabeed68@gmail.com"
} 