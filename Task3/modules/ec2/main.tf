resource "aws_instance" "ec2_public" {
  ami                         = "ami-011939b19c6bd1492"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.vpc.public_subnets[0]
  vpc_security_group_ids      = [var.sg_pub_id]

  tags = {
    "Name" = "${var.namespace}-EC2-PUBLIC"
  }

  provisioner "file" {
    source      = "./${var.key_name}.pem"
    destination = "/home/centos/${var.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = file("${var.key_name}.pem")
      host        = self.public_ip
    }
  }
  
  provisioner "remote-exec" {
    inline = ["chmod 400 ~/${var.key_name}.pem"]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = file("${var.key_name}.pem")
      host        = self.public_ip
    }

  }

}

resource "aws_instance" "ec2_private" {
  ami                         = "ami-019212a8baeffb0fa"
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.vpc.private_subnets[1]
  vpc_security_group_ids      = [var.sg_priv_id]

  tags = {
    "Name" = "${var.namespace}-EC2-PRIVATE"
  }

}