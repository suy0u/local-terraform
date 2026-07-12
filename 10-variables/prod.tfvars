# Auto Fill parameters for PROD

# File can be names as:
#   terraform.tfvars
#   prod.auto.tfvars
#   dev.auto.tfvars
#   terraform apply -var-file="prod.tfvars"


region                     = "ca-central-1"
instance_type              = "t3.small"
enable_detailed_monitoring = true

allow_ports                = ["80", "443", "8080"]

common_tags = {
  Project = "Obscurus"
  Environment = "prod"
}
