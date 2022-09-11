variable "region" {
  description = "The region to deploy to"
  default     = "ap-southeast-2"
}

variable "daily_budget_amount" {
  description = "The default amount for daily budget"
  default = 5
}

variable "default_subscription_email" {
  description = "default subscription email"
  default = "liucong.haonan@gmail.com"
}

variable "default_mle_admin" {
  description = "default user with DS permission"
  default = "dustinliu.mle.admin"
}

variable "default_ds_group" {
    description = "default group for DS users"
    default = "group.data"
}

