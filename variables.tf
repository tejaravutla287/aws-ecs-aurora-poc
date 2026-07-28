variable "aws_region" {}
variable "environment" {}
variable "project_name" {}
variable "image_uri" {}
variable "domain_name" {}
variable "hosted_zone_name" {}
variable "certificate_arn" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
