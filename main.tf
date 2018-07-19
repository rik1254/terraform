provider "aws" {
  access_key      = "${var.access_key}"
  secret_key      = "${var.secret_key}"
  region          = "${var.region}"
}

resource "aws_instance" "test_instance" {
  ami             = "${var.ami}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.aws_key_name}"
  tags {
    Name          = "CentOS_Puppet_Master"
    puppet_role   = "puppetmaster"
  }
  security_groups = ["allow_ssh", "default"]
  user_data       = "${file("script.sh")}"
  provisioner "file" {
    source        = "script.sh"
    destination   = "/home/centos/script.sh"
  }
}

resource "aws_security_group" "allow_ssh" {
    name          = "allow_ssh"
    description   = "Allow ssh"
    ingress {
      from_port   = 0
      to_port     = 22
      protocol    = "TCP"
      cidr_blocks = ["${var.ssh_cidr}"]
    }
}
