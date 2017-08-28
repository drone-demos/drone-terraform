###############################################################################
# Google Cloud
###############################################################################
provider "google" {
    credentials = "${file("gcp-credentials.json")}"
    project = "project-here"
    region = "us-west1"
}
