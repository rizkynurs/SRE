output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.template.id
}

output "launch_template_name" {
  description = "The name of the launch template"
  value       = aws_launch_template.template.name
}

output "autoscaling_group_id" {
  description = "The AutoScaling Group id"
  value       = aws_autoscaling_group.group.id
}

output "autoscaling_group_name" {
  description = "The AutoScaling Group name"
  value       = aws_autoscaling_group.group.name
}

output "autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = aws_autoscaling_group.group.min_size
}

output "autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = aws_autoscaling_group.group.max_size
}

output "nat_gateway_ip" {
  value = aws_eip.nat_gateway.public_ip
}

