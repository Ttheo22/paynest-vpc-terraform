# PayNest AWS Network Landing Zone

A production-inspired AWS networking foundation built with Terraform. This project provisions a secure, highly available Amazon VPC following cloud infrastructure best practices, including multi-AZ networking, private compute, Infrastructure as Code (IaC), and secure administrative access through AWS Systems Manager Session Manager.

> **Project Goal:** Demonstrate real-world AWS networking and Terraform skills by deploying a secure landing zone that mirrors patterns commonly used in production environments.

---

## Features

- Multi-AZ VPC architecture
- Public and private subnets across two Availability Zones
- Internet Gateway for public internet access
- NAT Gateway with Elastic IP for secure outbound internet access from private resources
- Public and private route tables
- Security groups following least-privilege principles
- Private EC2 instance with **no public IP**
- AWS Systems Manager Session Manager access (no SSH keys or bastion host required)
- Consistent resource tagging

---

## Architecture

```text
                           Internet
                               │
                      Internet Gateway
                               │
        ┌────────────────────────────────────┐
        │              AWS VPC               │
        │           10.0.0.0/16              │
        │                                    │
        │  Public Subnet A    Public Subnet B│
        │   10.0.1.0/24        10.0.2.0/24   │
        │        │                 │         │
        │        └──── NAT Gateway ──────────┘
        │                 │                  │
        │         Private Route Table        │
        │                 │                  │
        │ Private Subnet A   Private Subnet B│
        │ 10.0.3.0/24        10.0.4.0/24     │
        │        │                           │
        │   EC2 Instance                     │
        │ (Private, SSM Only)                │
        └────────────────────────────────────┘
```

---

## Design Decisions

This architecture reflects common AWS networking patterns used in production environments.

- EC2 instances are deployed in private subnets to reduce the attack surface.
- AWS Systems Manager Session Manager replaces SSH, eliminating the need for key management and bastion hosts.
- A NAT Gateway enables outbound internet access for private resources while preventing direct inbound internet exposure.
- Public subnets are reserved for internet-facing resources such as Application Load Balancers.
- Resources are distributed across multiple Availability Zones to improve resilience and availability.

---

## Infrastructure Provisioned

| Resource | Description |
|----------|-------------|
| **VPC** | `10.0.0.0/16` |
| **Public Subnets** | `10.0.1.0/24`, `10.0.2.0/24` |
| **Private Subnets** | `10.0.3.0/24`, `10.0.4.0/24` |
| **Internet Gateway** | Enables internet connectivity for public resources |
| **NAT Gateway** | Allows outbound internet access from private resources |
| **Elastic IP** | Static public IP attached to the NAT Gateway |
| **Route Tables** | Separate public and private routing |
| **Security Groups** | Least-privilege network access |
| **IAM Role & Instance Profile** | Enables AWS Systems Manager |
| **Private EC2 Instance** | Amazon Linux 2023 with no public IP |

---

## Security Design

This project follows AWS security best practices.

- Private EC2 instance has **no public IP address**
- No inbound SSH access
- Administrative access is provided exclusively through AWS Systems Manager Session Manager
- Security groups enforce least-privilege access
- Session activity can be audited using AWS CloudTrail and Systems Manager session logging when enabled in the AWS account
- Public security group allows HTTP (80) and HTTPS (443) for future internet-facing services

---

## Terraform Features

- Infrastructure as Code (IaC)
- Reusable input variables
- Outputs for key infrastructure resources
- Consistent resource tagging
- Automatic dependency management
- Declarative infrastructure provisioning

---

## Prerequisites

Before deploying, ensure you have:

- Terraform **1.0+**
- AWS CLI configured with valid credentials
- IAM permissions to provision:
  - VPC
  - EC2
  - IAM
  - Systems Manager
  - Networking resources

---

## Deployment

Clone the repository:

```bash
git clone https://github.com/Ttheo22/paynest-vpc-terraform.git
cd paynest-vpc-terraform
```

Initialize Terraform:

```bash
terraform init
```

Review the execution plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Destroy all resources when finished:

```bash
terraform destroy
```

---

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `region` | AWS Region | `us-east-1` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `public_subnet_cidrs` | Public subnet CIDRs | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `private_subnet_cidrs` | Private subnet CIDRs | `["10.0.3.0/24", "10.0.4.0/24"]` |
| `availability_zones` | Availability Zones | `["us-east-1a", "us-east-1b"]` |
| `instance_type` | EC2 instance type | `t3.micro` |
| `project` | Project tag | `PayNest` |
| `environment` | Environment tag | `Dev` |

---

## Outputs

| Output | Description |
|---------|-------------|
| `vpc_id` | VPC ID |
| `public_subnet_ids` | Public subnet IDs |
| `private_subnet_ids` | Private subnet IDs |
| `private_instance_id` | EC2 instance ID |

---

## Resource Tags

All resources are tagged consistently.

```text
Project     = PayNest
Environment = Dev
```

---

## Connecting to the EC2 Instance

Since the instance has **no public IP address**, access is provided through AWS Systems Manager Session Manager.

1. Open the AWS Console.
2. Navigate to **Systems Manager**.
3. Select **Session Manager**.
4. Click **Start Session**.
5. Choose **PayNest-private-instance**.
6. Click **Connect**.

No SSH keys, bastion host, or open inbound ports are required.

---

## Cost Notice

This project provisions a **NAT Gateway** and an **Elastic IP**, which may incur AWS charges while the infrastructure is running.

To avoid unnecessary costs after testing:

```bash
terraform destroy
```

---

## Future Improvements

- Refactor into reusable Terraform modules
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Remote Terraform state with S3 and DynamoDB
- VPC Flow Logs
- CloudWatch monitoring and alarms
- GitHub Actions CI/CD pipeline
- Multiple environments (Development, Staging, Production)

---

## AWS Best Practices Demonstrated

- Infrastructure as Code with Terraform
- Multi-AZ network design
- Private compute resources
- Least-privilege security
- Secure administrative access using AWS Systems Manager
- No public SSH access
- Consistent resource tagging
- Secure network segmentation with public and private subnets

---

## License

This project is provided for educational and portfolio purposes.