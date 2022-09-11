provider "aws" {
  region = var.region
}

// Define budgets report
// You will use the root credentials set in TF cloud to create
resource "aws_budgets_budget" "daily-cost-budget-notification" {
  name = "budget-all-services-daily"
  budget_type = "COST"
  limit_amount = var.daily_budget_amount
  limit_unit  = "USD"
  time_unit = "DAILY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold = "80"
    threshold_type = "PERCENTAGE"
    notification_type = "ACTUAL"
    subscriber_email_addresses = [var.default_subscription_email]
  }
}

//Define a default user for daily operations and add it to the default group defined in later section
//Here we are not following AWS best practices per mentioned in https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest
//TODO - refactoring by following the AWS best practices
module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.3.2"
  name = var.default_ds_user
  pgp_key = "keybase:dustinliu"
  force_destroy = true
  tags = {
    Team = "Data"
  }
}

//Define a default group with permission to operate Data Science operations plus permission to change user password
module "iam_iam-group-with-policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.3.2"
  name = var.default_ds_group
  group_users = [
    module.iam_iam-user.iam_user_name
]
  // so uer can change password
  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
  "arn:aws:iam::aws:policy/job-function/DataScientist",
  ]
  tags = {
    Team = "Data"
  }
}



