locals {
  name     = "prod"
  vpc_cidr = "10.70.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example    = local.name
    GithubRepo = "clauddy-class-devops"
    GithubOrg  = "clauddy"
  }



}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../modules/vpc"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  # #   create_database_subnet_group  = false
  # manage_default_network_acl    = false
  # manage_default_route_table    = false
  # manage_default_security_group = false

  # enable_dns_hostnames = true
  # enable_dns_support   = true

  # enable_nat_gateway = true
  # single_nat_gateway = true


  # #   enable_vpn_gateway = true

  # enable_dhcp_options              = true
  # dhcp_options_domain_name         = "service.consul"
  # dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  #   # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  #   enable_flow_log                      = true
  #   create_flow_log_cloudwatch_log_group = true
  #   create_flow_log_cloudwatch_iam_role  = true
  #   flow_log_max_aggregation_interval    = 60

  #   tags = local.tags
}





