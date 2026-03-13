resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-sg"
  description = "Allow All inbound traffic"

  ingress {
    description = "Allows SSH access"
    from_port   = var.port_no_of_ssh
    to_port     = var.port_no_of_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows App Access"
    from_port   = var.port_no
    to_port     = var.port_no
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows Prometheus To Access NodeExporter"
    from_port   = var.port_no_of_node_exporter
    to_port     = var.port_no_of_node_exporter
    protocol    = "tcp"
    cidr_blocks = var.prometheus_server
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-${var.env}-sg"
  }
}