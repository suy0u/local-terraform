# Auto Fill parameters for DEV

# File can be names as:
#   terraform.tfvars
#   prod.auto.tfvars
#   dev.auto.tfvars


region                     = "ca-central-1"
instance_type              = "t3.micro"
enable_detailed_monitoring = false

allow_ports                = ["80", "22", "8080"]

common_tags = {
  Project = "Obscurus"
  Environment = "dev"
}
