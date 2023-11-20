################################################################################
# Auto Scaling Group Module
################################################################################

module "asg" {
  source = "../../modules/asg"

  ############### Autoscaling group ###############

  name            = "${var.environment}-asg"
  use_name_prefix = false
  instance_name   = "${var.environment}-web-server"

  ignore_desired_capacity_changes = false

  min_size                  = 2
  max_size                  = 3
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  default_instance_warmup   = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets

  ##################################################
  # Launch template section
  #################################################S

  launch_template_name        = "${var.environment}-lt"
  launch_template_description = "Prod launch template"
  update_default_version      = true

  image_id = data.aws_ami.ubuntu_20.id
  # image_id          = data.aws_ami.packer_ubuntu.id
  instance_type     = var.instance_type
  key_name          = var.key_pair_use2
  user_data         = base64encode(file("user-data.sh"))
  enable_monitoring = true

  create_iam_instance_profile = false
  iam_instance_profile_arn    = data.aws_iam_instance_profile.base_role.arn

  # Security group is set on the ENIs below
  security_groups = [module.private_sg.security_group_id]

  target_group_arns = module.alb.target_group_arns

  maintenance_options = {
    auto_recovery = "default"
  }

  tags = {
    Name         = "${var.environment}-lt"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

}