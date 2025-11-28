resource "aws_instance" "eks" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids  = [aws_security_group.eks_sg_group.id]
    iam_instance_profile = aws_iam_instance_profile.eks.name

    root_block_device {
        volume_size = 50
        volume_type = "gp3" # or "gp2", depending on your preference
    }
    
    user_data = file("workstation.sh")

    tags ={
            Name = "eks"
          }
}

resource "aws_iam_instance_profile" "eks" {
    name = "eks"
    role = "BastionTerraformAdmin"
}

resource "aws_security_group" "eks_sg_group" {
  name        = "eks_sg_group"
  description = "SSH traffic"

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Represents all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks_sg_group"
  }
}