output "web_server_instance_id" {
  value = aws_instance.web_server.id
}

output "web_server_public_ip_address" {
  value = aws_eip.test_static_ip.public_ip
}

output "web_server_sg" {
  value = aws_security_group.webserver_sg.id
}

output "web_server_sg_arn" {
  value       = aws_security_group.webserver_sg.arn
  description = "This is Security Group ARN"
}
