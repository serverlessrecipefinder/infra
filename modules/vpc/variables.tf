variable "tags" {
  type        = "map"
  description = "Tags to apply to resources in the module"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = ""
}
