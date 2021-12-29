variable "default_tags" {
  type = map
  default = null
}

variable "asg_vpc_zone_identifier" {
  type        = list(string)
  description = "The created ASG will spawn instances to these subnet IDs"
}