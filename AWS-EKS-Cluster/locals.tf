locals {
  rds-master-username = var.resource-prefix
  rds-master-password = "${var.resource-prefix}-admin"
}
