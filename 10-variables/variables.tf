variable "region" {
  description = "Default region"
  type        = string            # string, list, map, bool
  default     = "us-east-1"
}

variable "owner" {
  default = "suy0u"
}

variable "createdby" {
  default = "Terraform"
}

variable "instance_type" {
  description = "Enter Instancce Type"
  default     = "t3.micro"
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list
  default     = [80, 443, 22, 8080]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = "true"
}

variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map
  default     = {
    Project     = "Obscurus"
    Environment = "dev" 
  }
}
