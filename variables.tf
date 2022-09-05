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


