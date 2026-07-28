module "ecs" {
  source = "./modules/ecs"

  environment      = var.environment
  image_uri        = var.image_uri
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  target_group_arn = module.alb.target_group_arn
  db_endpoint      = module.aurora.endpoint
}
