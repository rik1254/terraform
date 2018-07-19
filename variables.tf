variable "region" {
  description   = "london"
  default       = "eu-west-2"
}
variable "instance_type" {
  description   = "Puppet master instance type"
  default       = "t2.micro"
}
variable "ami" {
  description   = "Machine version"
  default       = "ami-00846a67"
}
variable "aws_key_name" {
  description   = "Name of keypair"
  default       = "testing-keypair"
}
