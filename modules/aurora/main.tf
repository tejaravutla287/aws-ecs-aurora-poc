resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-db-subnet"
  subnet_ids = var.database_subnets
}

resource "aws_security_group" "aurora" {
  name   = "${var.environment}-db-sg"
  vpc_id = var.vpc_id
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = "${var.environment}-aurora"
  engine             = "aurora-postgresql"

  master_username = var.db_username
  master_password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  storage_encrypted      = true
  skip_final_snapshot    = true

  enabled_cloudwatch_logs_exports = ["postgresql"]

  vpc_security_group_ids = [
    aws_security_group.aurora.id
  ]
}

resource "aws_rds_cluster_instance" "this" {
  count              = 2
  cluster_identifier = aws_rds_cluster.this.id
  identifier         = "${var.environment}-${count.index}"
  instance_class     = "db.t4g.medium"
  engine             = aws_rds_cluster.this.engine
}
