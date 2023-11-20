##################################################################
# Application Load Balancer
##################################################################

module "alb" {
  source = "../../modules/alb"

  name               = "${var.environment}-lb"
  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # Attach security groups
  security_groups = [module.public_sg.security_group_id]

  # # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  # access_logs = {
  #   bucket = module.log_bucket.s3_bucket_id
  # }

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = var.port_443
        protocol    = var.protocol_443
        status_code = "HTTP_301"
      }
    },
  ]

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.aws_acm_certificate.prod_clauddy_ssl_cert.arn
      # target_group_index = 0
    },
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]

      conditions = [{
        path_patterns = ["www.toleboy.com"]
      }]
    },
  ]

  target_groups = [
    {
      name                              = "${var.environment}-80-tg"
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      health_check = {
        enabled             = true
        interval            = 10
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"

      tags = {
        Name        = "${var.environment}-80-lt"
        Env         = var.environment
        Provisioner = var.provisioner
      }
    },

  ]

  lb_tags = {
    Name        = "${var.environment}-lb"
    Env         = var.environment
    Provisioner = var.provisioner
  }

}

