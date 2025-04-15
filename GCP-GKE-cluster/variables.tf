variable "gcp_project" {
  
}

variable "gcp_region" {
  default = "asia-east2"
}

variable "gcp_zone" {
  default = "asia-east2-a"
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}