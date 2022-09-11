//TODO split the init setup - role, group, etc into a separate module
//assume role will be used to create resources once initial setting is done

provider "aws" {
  region = var.region
  shared_config_files = ["/Users/dustinl/.aws/config"]
  shared_credentials_files = ["/Users/dustinl/.aws/credentials"]
  assume_role {
    role_arn     = "arn:aws:iam::967632065582:role/RoleForMLE"
  }
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

module "iam_iam-account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-account"
  version = "5.3.2"
  minimum_password_length = 8
  require_uppercase_characters = true
  account_alias = "dustinliudev1"

}

module "iam_iam-assumable-role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.3.2"
  attach_admin_policy = true
  trusted_role_arns = [
    "arn:aws:iam::967632065582:root",
    module.iam_iam-user.iam_user_arn
  ]
  create_role = true
  role_name = "RoleForMLE"
  role_requires_mfa = false
}


module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.3.2"
  name = var.default_mle_admin
  pgp_key = "keybase:dustinliu"
  force_destroy = true
  tags = {
    Team = "Data"
  }
}


module "iam_iam-group-with-assumable-roles-policy" {
  source          = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version         = "5.3.2"
  name            = "data-operations"
  assumable_roles = [
    module.iam_iam-assumable-role.iam_role_arn
  ]
  group_users = [
    module.iam_iam-user.iam_user_name
  ]
  tags = {
    Team = "Data"
  }
}






