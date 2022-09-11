
output "user_keybase_password_decrypt_command" {
  description = "keybase_password_decrypt_command"
  value       = module.iam_iam-user.keybase_password_decrypt_command
}

output "user_keybase_secret_key_decrypt_command" {
  description = "keybase_secret_key_decrypt_command"
  value = module.iam_iam-user.keybase_secret_key_decrypt_command
}
