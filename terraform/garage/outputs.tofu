output "keys" {
  description = "Garage keys, keyed by stable logical name"
  value       = { for name, key in garage_key.this : name => key }
}