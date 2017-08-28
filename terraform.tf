###############################################################################
# Terraform
###############################################################################
terraform {
    backend "gcs" {
        bucket  = "drone-terraform-state"
        path    = "terraform.tfstate"
        project = "project-here"
    }
}
