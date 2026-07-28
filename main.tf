module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
}

module "alb" {
  source           = "./modules/alb"
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  public_subnets   = module.vpc.public_subnets
  certificate_arn  = var.certificate_arn
}

module "aurora" {
  source           = "./modules/aurora"
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  database_subnets = module.vpc.database_subnets
  db_username      = var.db_username
  db_password      = var.db_password
}

module "ecs" {
  source            = "./modules/ecs"
  environment       = var.environment
  image_uri         = var.image_uri
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  target_group_arn  = module.alb.target_group_arn
  db_endpoint       = module.aurora.endpoint
}

module "route53" {
  source        = "./modules/route53"
  environment   = var.environment
  hosted_zone   = var.hosted_zone_name
  alb_dns_name  = module.alb.alb_dns_name
  alb_zone_id   = module.alb.alb_zone_id
}
