provider "aws" {
    # Credentials are defined in the environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
    region = var.region
}


# Create the SSH key pair
resource "aws_lightsail_key_pair" "scale_key_pair" {
  name       = "scale_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}


# Create the instance and its DNS entries
resource "aws_lightsail_instance" "scale_instance" {
  name              = "scale_instance"
  availability_zone = "${var.region}a"
  blueprint_id      = var.operating_system
  bundle_id         = var.size
  key_pair_name     = "scale_key_pair"
  depends_on        = [aws_lightsail_key_pair.scale_key_pair]
}
resource "aws_route53_record" "apex" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  ttl     = "60"
  records = [aws_lightsail_instance.scale_instance.public_ip_address]
}
