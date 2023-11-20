############## Environment Variable #################################
variable "environment" {
  type    = string
  default = "prod"
}

########## Provisioner Variable ################################
variable "provisioner" {
  type    = string
  default = "Terrafform"

}

############ Public SG Variable ########################
variable "public_sg_name" {
  type    = string
  default = "public-sg"
}

############ Private SG Variable ########################
variable "private_sg_name" {
  type    = string
  default = "private-sg"
}

############ Bastion SG Variable ########################
variable "bastion_sg_name" {
  type    = string
  default = "bastion-sg"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"

}

variable "key_pair_use2" {
  type    = string
  default = "main-us-east-2"
}

################## Ports and Protocols variables ####################

variable "port_443" {
  type    = number
  default = "443"
}

variable "protocol_443" {
  type    = string
  default = "HTTPS"
}

variable "port_80" {
  type    = number
  default = "80"
}

variable "protocol_80" {
  type    = string
  default = "HTTP"
}

variable "port_22" {
  type    = number
  default = "22"
}

variable "protocol_tcp" {
  type    = string
  default = "TCP"
}
