variable "bucket_name" {
  type        = string
  description = "Globally unique bucket name"
}

variable "expire_old_versions_after_days" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_public_read" {
  type        = bool
  description = "Enable/disable public read access to objects"
  default     = false
}
