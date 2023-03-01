resource "aws_instance" "bastion_host" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.bastion_instance_type
  subnet_id              = var.public_subnet_id[0].id
  vpc_security_group_ids = [var.sg.id]
  availability_zone      = var.availability_zones
  key_name               = var.keyname
  tags = {
    Name = "bastion_host"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = var.private_key
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y && sudo apt upgrade -y",
      "sudo apt install awscli -y",
      "sudo apt-get install curl wget unzip zip -y",
      "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "sudo apt-get update -y",
      "sudo apt-get install jq -y",
      "curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin",
      "echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc",
      "kubectl version --short --client",
      "curl --silent --location https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz | tar xz -C /tmp",
      "sudo mv /tmp/eksctl /usr/local/bin",
      "export AWS_ACCESS_KEY_ID=${var.access_key}",
      "export AWS_SECRET_ACCESS_KEY=${var.secret_key}",
      "export AWS_DEFAULT_REGION=${var.region}",
      "aws sts get-caller-identity",
      "aws eks update-kubeconfig --region ${var.region} --name ${var.cluster_name}",
      "eksctl utils write-kubeconfig --cluster=${var.cluster_name} --set-kubeconfig-context=true",
      "eksctl utils associate-iam-oidc-provider --cluster=${var.cluster_name} --approve",
      "kubectl get nodes"
    ]
  }
}
