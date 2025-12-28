# 🚀 Production-Grade AKS Platform Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)

> A complete, production-ready Azure Kubernetes Service (AKS) platform with AWS S3 integration. This repository contains everything you need to deploy a secure, scalable, and compliant Kubernetes infrastructure from scratch.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Setup](#detailed-setup)
- [Project Structure](#project-structure)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This project provides a battle-tested infrastructure-as-code solution for deploying a production-grade AKS cluster with:

- **Private AKS cluster** with Azure CNI networking
- **Multi-cloud integration** (Azure + AWS S3)
- **Zero-trust network policies**
- **Auto-scaling** capabilities (HPA + Cluster Autoscaler)
- **Enterprise security** (Key Vault, RBAC, Workload Identity)
- **Observability** (Log Analytics integration)

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Azure Cloud                          │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              VNet (10.0.0.0/16)                       │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │   AKS Subnet (10.0.1.0/24)                      │  │  │
│  │  │                                                  │  │  │
│  │  │   ┌──────────────────────────────────────┐      │  │  │
│  │  │   │  Private AKS Cluster                 │      │  │  │
│  │  │   │  - System Node Pool (2-5 nodes)      │      │  │  │
│  │  │   │  - Azure CNI + Calico                │      │  │  │
│  │  │   │  - Workload Identity Enabled         │      │  │  │
│  │  │   └──────────────────────────────────────┘      │  │  │
│  │  │                                                  │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │                                                         │  │
│  │  [ACR]  [Key Vault]  [Log Analytics]  [NSG]            │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                           │
│  [S3 Bucket] - Encrypted, Versioned, Private                │
└─────────────────────────────────────────────────────────────┘
```

## ✨ Features

### Infrastructure
- ✅ **Private AKS Cluster** - No public API endpoint
- ✅ **Azure CNI Networking** - Native VNet integration
- ✅ **Calico Network Policies** - Enhanced security
- ✅ **Auto-scaling** - Both pod and node level
- ✅ **Premium ACR** - Container registry with geo-replication support
- ✅ **Azure Key Vault** - Secrets management
- ✅ **Log Analytics** - Centralized logging and monitoring

### Security
- 🔒 **Zero-trust network policies** - Default deny egress
- 🔒 **RBAC enabled** - Azure AD integration
- 🔒 **Workload Identity** - No static credentials
- 🔒 **Private endpoints** - No public exposure
- 🔒 **Encrypted S3** - Server-side encryption enabled
- 🔒 **NSG protection** - Network-level security

### Kubernetes Components
- 📦 Production-ready deployments
- 📦 Service mesh ready
- 📦 Ingress controller support (NGINX)
- 📦 Horizontal Pod Autoscaler (HPA)
- 📦 Network policies for egress control

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

| Tool | Version | Installation |
|------|---------|--------------|
| Terraform | >= 1.6.0 | [Download](https://www.terraform.io/downloads) |
| Azure CLI | Latest | [Download](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) |
| AWS CLI | Latest | [Download](https://aws.amazon.com/cli/) |
| kubectl | Latest | [Download](https://kubernetes.io/docs/tasks/tools/) |
| Helm | >= 3.0 | [Download](https://helm.sh/docs/intro/install/) |

**Verify installations:**
```bash
terraform --version
az --version
aws --version
kubectl version --client
helm version
```

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/aks-platform.git
cd aks-platform
```

### 2. Setup Azure Backend (One-time)
```bash
az login
az group create -n tf-backend-rg -l eastus

az storage account create \
  -n tfbackendprod \
  -g tf-backend-rg \
  -l eastus \
  --sku Standard_LRS

az storage container create \
  -n tfstate \
  --account-name tfbackendprod
```

### 3. Configure AWS
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: us-east-1
# Default output format: json
```

### 4. Initialize and Deploy
```bash
terraform init
terraform validate
terraform plan
terraform apply
```

⏱️ **Deployment time:** ~20-30 minutes

### 5. Configure kubectl
```bash
az aks get-credentials -n prod-aks -g prod-aks-rg
kubectl get nodes
```

### 6. Deploy Sample Application
```bash
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
kubectl apply -f kubernetes/ingress.yaml
kubectl apply -f kubernetes/hpa.yaml
kubectl apply -f kubernetes/network-policy.yaml
```

## 📖 Detailed Setup

### Phase 0: Prerequisites

#### Install Required Tools
```bash
# macOS (using Homebrew)
brew install terraform azure-cli awscli kubectl helm

# Linux (Ubuntu/Debian)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Phase 1: Terraform Infrastructure

#### Project Structure
```bash
mkdir -p aks-platform/{azure,aws,kubernetes}
cd aks-platform
touch providers.tf backend.tf variables.tf terraform.tfvars
```

#### Create Terraform Files

**providers.tf**
```hcl
terraform {
  required_version = ">= 1.6.0"
}

provider "azurerm" {
  features {}
}

provider "aws" {
  region = var.aws_region
}
```

**backend.tf**
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tf-backend-rg"
    storage_account_name = "tfbackendprod"
    container_name       = "tfstate"
    key                  = "aks-platform.tfstate"
  }
}
```

**variables.tf**
```hcl
variable "location" {
  description = "Azure region for resources"
  default     = "East US"
}

variable "aws_region" {
  description = "AWS region for S3 bucket"
  default     = "us-east-1"
}
```

**azure/rg.tf**
```hcl
resource "azurerm_resource_group" "rg" {
  name     = "prod-aks-rg"
  location = var.location
}
```

**azure/network.tf**
```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "prod-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "aks_nsg" {
  name                = "aks-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}
```

**azure/loganalytics.tf**
```hcl
resource "azurerm_log_analytics_workspace" "law" {
  name                = "prod-aks-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}
```

**azure/aks.tf**
```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "prod-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "prodaks"

  private_cluster_enabled = true

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                = "system"
    vm_size             = "Standard_D4s_v5"
    node_count          = 2
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 5
    vnet_subnet_id      = azurerm_subnet.aks.id
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  role_based_access_control_enabled = true

  azure_active_directory_role_based_access_control {
    managed = true
  }

  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }
}
```

**azure/acr.tf**
```hcl
resource "azurerm_container_registry" "acr" {
  name                = "prodacr12345"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Premium"
  admin_enabled       = false
}
```

**azure/keyvault.tf**
```hcl
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "prod-kv-aks"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
}
```

**aws/s3.tf**
```hcl
resource "aws_s3_bucket" "bucket" {
  bucket = "prod-aks-secure-bucket"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "enc" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

### Phase 2: Kubernetes Manifests

**kubernetes/namespace.yaml**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: prod
```

**kubernetes/deployment.yaml**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  namespace: prod
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: prodacr.azurecr.io/myapp:1.0.0
        ports:
        - containerPort: 8080
        resources:
          requests:
            cpu: "200m"
            memory: "256Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
```

**kubernetes/service.yaml**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-svc
  namespace: prod
spec:
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 8080
```

**kubernetes/ingress.yaml**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
  namespace: prod
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp-svc
            port:
              number: 80
```

**kubernetes/network-policy.yaml**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-egress
  namespace: prod
spec:
  podSelector: {}
  policyTypes:
  - Egress
```

**kubernetes/hpa.yaml**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
  namespace: prod
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## 📁 Project Structure

```
aks-platform/
├── README.md
├── LICENSE
├── .gitignore
├── providers.tf           # Cloud provider configurations
├── backend.tf            # Terraform state backend
├── variables.tf          # Input variables
├── terraform.tfvars      # Variable values (add to .gitignore)
├── azure/
│   ├── rg.tf            # Resource group
│   ├── network.tf       # VNet, Subnet, NSG
│   ├── aks.tf           # AKS cluster configuration
│   ├── acr.tf           # Container registry
│   ├── keyvault.tf      # Key Vault
│   └── loganalytics.tf  # Log Analytics workspace
├── aws/
│   └── s3.tf            # S3 bucket with security
└── kubernetes/
    ├── namespace.yaml
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml
    ├── hpa.yaml
    └── network-policy.yaml
```

## 🔒 Security

This infrastructure implements multiple layers of security:

### Network Security
- Private AKS cluster (no public API endpoint)
- Network Security Groups (NSG) for subnet protection
- Calico network policies for pod-level security
- Default deny-all egress network policy

### Identity & Access Management
- Azure AD RBAC integration
- Workload Identity (no static credentials)
- System-assigned managed identity for AKS
- Premium ACR with admin access disabled

### Data Protection
- S3 bucket with server-side encryption (AES256)
- S3 versioning enabled for data recovery
- S3 public access blocked at all levels
- Azure Key Vault for secrets management

### Monitoring & Compliance
- Log Analytics integration for centralized logging
- Container insights enabled
- Audit logs for compliance

## 🔧 Customization

### Modify Resource Names
Edit `variables.tf` and add your custom values:

```hcl
variable "resource_prefix" {
  description = "Prefix for all resources"
  default     = "prod"
}

variable "aks_node_count" {
  description = "Initial node count"
  default     = 2
}
```

### Change Azure Region
Update the `location` variable in `variables.tf`:

```hcl
variable "location" {
  default = "West Europe"  # or any other Azure region
}
```

### Adjust Node Sizes
In `azure/aks.tf`, modify the `vm_size`:

```hcl
default_node_pool {
  vm_size = "Standard_D8s_v5"  # Larger nodes
  # ...
}
```

## 📊 Monitoring

### View Cluster Health
```bash
kubectl get nodes
kubectl get pods -A
kubectl top nodes
kubectl top pods -n prod
```

### Check Logs
```bash
# Pod logs
kubectl logs -n prod deployment/myapp

# Follow logs
kubectl logs -n prod deployment/myapp -f

# Previous container logs
kubectl logs -n prod deployment/myapp --previous
```

### Azure Monitor
Access your Log Analytics workspace:
```bash
az monitor log-analytics workspace show \
  -g prod-aks-rg \
  -n prod-aks-law
```

## 🧪 Testing

### Verify Deployment
```bash
# Check deployment status
kubectl rollout status deployment/myapp -n prod

# Test service connectivity
kubectl run -it --rm debug --image=busybox --restart=Never -- \
  wget -O- http://myapp-svc.prod.svc.cluster.local

# Verify HPA
kubectl get hpa -n prod
```

### Load Testing
```bash
# Generate load to test autoscaling
kubectl run -it --rm load-generator --image=busybox --restart=Never -- /bin/sh -c \
  "while true; do wget -q -O- http://myapp-svc.prod.svc.cluster.local; done"
```

## 🚨 Troubleshooting

### Common Issues

**Issue: Cannot connect to AKS cluster**
```bash
# Re-authenticate
az login
az aks get-credentials -n prod-aks -g prod-aks-rg --overwrite-existing
```

**Issue: Pods not starting**
```bash
# Check pod events
kubectl describe pod <pod-name> -n prod

# Check node resources
kubectl describe node <node-name>
```

**Issue: Terraform state locked**
```bash
# Force unlock (use with caution)
terraform force-unlock <lock-id>
```

## 🗑️ Cleanup

To destroy all resources:

```bash
# Delete Kubernetes resources first
kubectl delete namespace prod

# Destroy Terraform infrastructure
terraform destroy

# Clean up backend (optional)
az storage container delete -n tfstate --account-name tfbackendprod
az group delete -n tf-backend-rg --yes
```

## 📚 Additional Resources

- [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Calico Network Policies](https://docs.projectcalico.org/security/calico-network-policy)
- [Azure Well-Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/)

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code follows best practices and includes appropriate documentation.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Support

If you find this project helpful, please give it a star! ⭐

## 📧 Contact

For questions or support, please open an issue in the GitHub repository.

---

**Made with ❤️ for the DevOps community**

## ✅ Deployment Checklist

- [ ] Install all prerequisites
- [ ] Create Azure storage backend
- [ ] Configure AWS credentials
- [ ] Review and customize variables
- [ ] Run `terraform init`
- [ ] Run `terraform plan`
- [ ] Run `terraform apply`
- [ ] Get AKS credentials
- [ ] Deploy Kubernetes manifests
- [ ] Verify all resources
- [ ] Configure monitoring alerts
- [ ] Document custom changes
- [ ] Set up CI/CD (future phase)

## 🎯 Roadmap

- [x] Basic infrastructure setup
- [x] Private AKS cluster
- [x] Auto-scaling configuration
- [x] Network policies
- [ ] GitOps with ArgoCD
- [ ] Service mesh (Istio/Linkerd)
- [ ] Advanced monitoring (Prometheus/Grafana)
- [ ] Disaster recovery setup
- [ ] Multi-region deployment
- [ ] Cost optimization strategies
