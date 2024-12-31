variable "monitored_instance_ids" {
  description = "List of instance IDs to monitor"
  type        = list(string)
}

variable "env_prefix" {
  description = "Environment prefix for resources"
  type        = string
}