# PayNest – Production-Inspired AWS Landing Zone (Terraform)

A production-inspired AWS landing zone provisioned with Terraform. The infrastructure implements a secure, highly available networking foundation following AWS architectural best practices, including multi-AZ networking, private compute, load balancing, auto scaling, and secure administrative access through AWS Systems Manager Session Manager.

The solution demonstrates infrastructure-as-code principles, security-first design, and operational patterns commonly adopted in modern AWS environments.

---

## Architecture Highlights

- Multi-Availability Zone VPC architecture
- Public and private subnets across two Availability Zones
- Internet Gateway for public connectivity
- NAT Gateway with Elastic IP for secure outbound internet access from private workloads
- Internet-facing Application Load Balancer (ALB)
- Auto Scaling Group spanning private subnets
- Launch Template with automated Apache deployment
- CPU target tracking scaling policy
- Security groups implementing least-privilege access
- Administrative access via AWS Systems Manager Session Manager (no SSH)
- Consistent resource tagging for governance and cost allocation

---

## Architecture

```text
                            Internet
                                │
                       Internet Gateway
                                │
                     ┌──────────────────┐
                     │   ALB (Public)   │
                     │  HTTP/HTTPS      │
                     └────────┬─────────┘
                              │
         ┌────────────────────────────────────────┐
         │                AWS VPC                 │
         │             10.0.0.0/16                │
         │                                        │
         │   Public Subnet A    Public Subnet B   │
         │    10.0.1.0/24        10.0.2.0/24      │
         │         │                  │           │
         │         └──── NAT Gateway ─┘           │
         │                  │                     │
         │          Private Route Table           │
         │                  │                     │
         │  Private Subnet A    Private Subnet B  │
         │   10.0.3.0/24         10.0.4.0/24      │
         │         │                  │           │
         │    EC2 (ASG)          EC2 (ASG)        │
         │  Private Only       Private Only       │
         │   SSM Access         SSM Access        │
         └────────────────────────────────────────┘
```

---

## Design Principles

The infrastructure is designed around security, high availability, and operational simplicity.

### Secure by Default

- EC2 instances are deployed exclusively within private subnets.
- No instance is assigned a public IP address.
- Administrative access is provided through AWS Systems Manager Session Manager instead of SSH.
- Security groups enforce least-privilege communication between infrastructure components.
- The Application Load Balancer is the only public-facing component.

### High Availability

- Resources are distributed across two Availability Zones.
- Auto Scaling maintains application availability by replacing unhealthy instances.
- Application traffic is balanced across healthy targets by the ALB.

### Operational Efficiency

- Terraform manages the complete infrastructure lifecycle.
- Dynamic AMI lookup eliminates hardcoded image IDs.
- Consistent tagging simplifies resource management and cost allocation.

---

## Infrastructure Components

| Component | Purpose |
|-----------|---------|
| VPC | Isolated network environment |
| Public Subnets | Host internet-facing infrastructure |
| Private Subnets | Host application instances |
| Internet Gateway | Public internet connectivity |
| NAT Gateway | Outbound internet access for private resources |
| Route Tables | Public and private routing |
| Application Load Balancer | Distributes inbound traffic |
| Target Group | Health monitoring and request routing |
| Launch Template | Standardized EC2 configuration |
| Auto Scaling Group | Maintains application capacity |
| IAM Role & Instance Profile | Enables Systems Manager access |
| Security Groups | Enforce network access controls |

---

## Security Architecture

The deployment follows a defense-in-depth approach.

- No inbound SSH access
- No public IP addresses assigned to EC2 instances
- Private application tier isolated from direct internet access
- Security groups restrict traffic between infrastructure layers
- Administrative access exclusively through AWS Systems Manager Session Manager
- Session activity can be audited through AWS CloudTrail and Systems Manager logging

---

## Terraform Implementation

Key Terraform features used throughout the deployment include:

- Infrastructure as Code
- Reusable input variables
- Local values for centralized tagging
- Dynamic resource creation using `count`
- Collection expressions (`[*]`)
- `merge()` for tag composition
- `base64encode()` for EC2 user data
- `jsonencode()` for IAM policy generation
- Dynamic AMI lookup using data sources
- Automatic dependency management through resource references

---

## Repository Structure

```text
## Repository Structure

```text
.
├── alb.tf           # Application Load Balancer, Target Group, and Listener
├── compute.tf       # Launch Template, Auto Scaling Group, and Scaling Policy
├── iam.tf           # IAM Role and Instance Profile for Systems Manager
├── main.tf          # Provider configuration and networking resources
├── security.tf      # Security Groups
├── variables.tf     # Input variables
├── outputs.tf       # Terraform outputs
└── README.md
```

---

## Deployment

Clone the repository.

```bash
git clone https://github.com/Ttheo22/paynest-vpc-terraform.git

cd paynest-vpc-terraform
```

Initialize Terraform.

```bash
terraform init
```

Validate the configuration.

```bash
terraform validate
```

Review the execution plan.

```bash
terraform plan
```

Deploy the infrastructure.

```bash
terraform apply
```

After deployment, retrieve the Application Load Balancer DNS name.

```bash
curl http://<alb_dns_name>
```

Destroy the infrastructure when no longer required.

```bash
terraform destroy
```

---

## Configuration

| Variable | Default |
|----------|---------|
| region | us-east-1 |
| vpc_cidr | 10.0.0.0/16 |
| public_subnet_cidrs | 10.0.1.0/24, 10.0.2.0/24 |
| private_subnet_cidrs | 10.0.3.0/24, 10.0.4.0/24 |
| availability_zones | us-east-1a, us-east-1b |
| instance_type | t3.micro |
| project | PayNest |
| environment | Dev |

---

## Outputs

| Output | Description |
|---------|-------------|
| vpc_id | VPC identifier |
| public_subnet_ids | Public subnet IDs |
| private_subnet_ids | Private subnet IDs |
| alb_dns_name | Load Balancer endpoint |
| target_group_arn | Target Group ARN |

---

## Operational Validation

The deployed infrastructure was validated by confirming:

- Successful Terraform provisioning
- Healthy ALB target registration
- HTTP traffic routed exclusively through the ALB
- EC2 instances inaccessible from the public internet
- Administrative access functioning through Systems Manager Session Manager
- Outbound internet connectivity from private instances through the NAT Gateway
- Auto Scaling maintaining the desired application capacity

---

## Architecture Trade-offs

This implementation uses a single NAT Gateway shared across both private subnets to balance functionality and operating cost.

In production environments requiring maximum availability, a NAT Gateway would typically be deployed in each Availability Zone to eliminate cross-AZ dependencies. The current design intentionally favors cost efficiency while preserving the overall production architecture.

---

## Cost Considerations

This deployment provisions billable AWS resources including:

- NAT Gateway
- Elastic IP
- Application Load Balancer
- EC2 instances
- Data transfer

Destroy the infrastructure after testing to avoid unnecessary charges.

```bash
terraform destroy
```

---

## Roadmap

Future enhancements include:

- Modular Terraform architecture
- Remote state with S3 and DynamoDB locking
- HTTPS termination with ACM
- VPC Flow Logs
- CloudWatch dashboards and alarms
- GitHub Actions CI/CD pipeline
- Multiple deployment environments
- WAF integration
- AWS Config and GuardDuty

---

## AWS Practices Demonstrated

- Infrastructure as Code with Terraform
- Multi-AZ network architecture
- Private application infrastructure
- Load balancing and health checks
- Auto Scaling
- Least-privilege security model
- Systems Manager administrative access
- Dynamic infrastructure provisioning
- Consistent resource governance through tagging

---

## License

This repository is intended for portfolio and educational purposes.