resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_ec2_sg"
  }


}

resource "aws_instance" "ec2_instance" {
  ami             = "ami-0fef201115eefe936"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "terraform_ec2_instance"
  }
}