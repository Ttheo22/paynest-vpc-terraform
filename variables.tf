variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"

}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "list the public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List the private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "The AZs for the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "project" {
    description = "The project name for tagging resources"
    type        = string
  default = "Paynest"
}

variable "environment" {
    description = "The environment name"
    type        = string
  default = "Dev"
}