output "public_connection_string" {
  description = "Copy/Paste/Enter - For Public Centos instance"
  value       = "ssh -i ${module.ssh-key.key_name}.pem centos@${module.ec2.public_ip}"
}

output "private_connection_string" {
  description = "Copy/Paste/Enter - For private Ubuntu instance"
  value       = "ssh -i ${module.ssh-key.key_name}.pem ubuntu@${module.ec2.private_ip}"
}