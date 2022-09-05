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

module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.3.2"
  name = "dustin.liu.mle"
  pgp_key = "keybase:dustinliu"
  force_destroy = true
  tags = {
    Team = "Data"
  }
}


//Define a default group with permission to operate MLE operations


//Here we will be using IAM module from AWS


