################################################
# Public Security group
################################################
module "public_sg" {
  source = "../../modules/sg"

  name        = var.public_sg_name
  description = "Allow HTTP and HTTPS communication from Public"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.environment}-${var.public_sg_name}"
    Env         = var.environment
    Provisioner = var.provisioner
  }

  ### Ingress Rules for Public SG ####

  # Default CIDR blocks, which will be used for all ingress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]

  # HTTP and HTTPS From public IPV4

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allows HTTP comminucation from Everywhere"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allows HTTPS comminucation from Everywhere"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # HTTP and HTTPS From public IPV6

  ingress_with_ipv6_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allows HTTP comminucation from Everywhere"
      cidr_blocks = "::/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allows HTTPS comminucation from Everywhere"
      cidr_blocks = "::/0"
    },
  ]

  ### Egress Rules for Public SG ####

  # HTTP and HTTPS to Private SG

  egress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Allows HTTP communication to Provate SG"
      source_security_group_id = module.private_sg.security_group_id
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allows HTTPS communication to Provate SG"
      source_security_group_id = module.private_sg.security_group_id
    },
  ]

  # Default CIDR blocks, which will be used for all ingress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.

  #   egress_cidr_blocks = ["0.0.0.0/0"]
  #   egress_ipv6_cidr_blocks = ["::/0"]

  # HTTP and HTTPS to Everywhere IPV4

  #   egress_with_cidr_blocks = [
  #     {
  #       from_port   = 80
  #       to_port     = 80
  #       protocol    = "tcp"
  #       description = "Allows HTTP comminucation to Everywhere"
  #       cidr_blocks = "0.0.0.0/0"
  #     },
  #        {
  #       from_port   = 443
  #       to_port     = 443
  #       protocol    = "tcp"
  #       description = "Allows HTTPS comminucation to Everywhere"
  #       cidr_blocks = "0.0.0.0/0"
  #     },
  #   ]

  # HTTP and HTTPS to Everywhere IPV6

  #   egress_with_ipv6_cidr_blocks = [
  #     {
  #       from_port   = 80
  #       to_port     = 80
  #       protocol    = "tcp"
  #       description = "Allows HTTP comminucation to Everywhere"
  #       cidr_blocks = "::/0"
  #     },
  #        {
  #       from_port   = 443
  #       to_port     = 443
  #       protocol    = "tcp"
  #       description = "Allow HTTPS comminucation from Everywhere"
  #       cidr_blocks = "::/0"
  #     },
  #   ]

}


################################################
# Private Security group
################################################
module "private_sg" {
  source = "../../modules/sg"

  name        = var.private_sg_name
  description = "Allow HTTP and HTTPS communication from Bastion"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.environment}-${var.private_sg_name}"
    Env         = var.environment
    Provisioner = var.provisioner
  }

  ### Ingress Rules ####

  # HTTP and HTTPS from Public SG

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Allows HTTP communication from Public SG"
      source_security_group_id = module.public_sg.security_group_id
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allows HTTPS communication to Provate SG"
      source_security_group_id = module.public_sg.security_group_id
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "Allows SSH communication from Bastion SG"
      source_security_group_id = module.bastion_sg.security_group_id
    },
  ]

  # Egress Rules

  # Default CIDR blocks, which will be used for all ingress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.

  # All Traffic to Everywhere IPV4

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allows All Traffic commitonucation to Everywhere IPV4"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # All Traffic to Everywhere IPV6

  egress_with_ipv6_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allows All Traffic commitonucation to Everywhere IPV4"
      cidr_blocks = "::/0"
    },
  ]
}


################################################
# Bastion Security group
################################################
module "bastion_sg" {
  source = "../../modules/sg"

  name        = var.bastion_sg_name
  description = "Allows SSH communication from Private SG"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.environment}-${var.bastion_sg_name}"
    Env         = var.environment
    Provisioner = var.provisioner
  }

  ### Ingress Rules ####

  # Default CIDR blocks, which will be used for all ingress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.

  # All Traffic to Everywhere IPV4

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]

  # SSH from Everywhere IPV4

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allows SSH Traffic from Everywhere IPV4"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # SSH from Everywhere IPV6

  ingress_with_ipv6_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allows SSH Traffic from Everywhere IPV6"
      cidr_blocks = "::/0"
    },
  ]

  # Egress Rules

  # SSH to Private SG

  egress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "Allows HTTP communication from Public SG"
      source_security_group_id = module.private_sg.security_group_id
    },
  ]

}