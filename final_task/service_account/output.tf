output "sa-email" {
  value = google_service_account.sa.email
}

output "sa-name" {
  value = google_service_account.sa.name
}

//key

output "private_key" {
  value     = google_service_account_key.sa_key.private_key
  sensitive = true
}

output "decoded_private_key" {
  value     = base64decode(google_service_account_key.sa_key.private_key)
  sensitive = true
}