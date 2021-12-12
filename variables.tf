variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  type = string
  default = "ap-northeast-1"
}

variable "domain" {}

variable "account_id" {
  type = string
}


variable "db_name" {
  type        = string
}

variable "db_username" {
  type        = string
}

variable "db_password" {
  type        = string
}

variable "db_endpoint" {
  type        = string
}

variable "db_rails_env" {
  type        = string
}

variable "master_key" {
  type        = string
}



# variable "db_name" {
#   type = string
# }

# variable "db_password" {
#   type = string
# }