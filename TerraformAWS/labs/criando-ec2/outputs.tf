output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.ec2_sg.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.ec2_sg.name
}

output "public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = aws_instance.ec2_instance.public_dns
}