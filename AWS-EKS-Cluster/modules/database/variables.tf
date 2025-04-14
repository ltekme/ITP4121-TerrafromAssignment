variable "prefix" {
  description = "The preix for this resource"
  type        = string
}

variable "database-name" {
  description = "The name of the database"
  type        = string
}

variable "master-username" {
  description = "The default username of the master user"
  type        = string
}

variable "master-password" {
  description = "The default password for the master user"
  type        = string
}

variable "subnets" {
  description = "The subnets this db in"
  type        = list(string)
}

variable "additional-tags" {
  description = "addittional tags"
  type        = object({ string : string })
}
