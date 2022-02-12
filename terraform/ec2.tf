data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "description"
    values = ["${var.ami_description}*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_instance" "vm" {
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"
  associate_public_ip_address = false

  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.test-instance-security-group.id]
  iam_instance_profile = aws_iam_instance_profile.test-instance-profile.name

  tags = {
    Name = "test-instance"
  }
}

resource "aws_security_group" "test-instance-security-group" {
  name        = "test-instance-sg"
  description = "Rules for the EC2 test instance"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-instance-sg"
  }

  depends_on = [aws_nat_gateway.ngw]
}
