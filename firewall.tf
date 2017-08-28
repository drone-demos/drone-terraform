###############################################################################
# Firewall Rules
###############################################################################
resource "google_compute_firewall" "drone_server" {
    name = "drone-server"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80", "443"]
    }

    target_tags = ["drone-server"]
}

resource "google_compute_firewall" "drone_server_grpc" {
    name = "drone-server-grpc"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["9000"]
    }

    source_tags = [
        "drone-client"
    ]
    target_tags = ["drone-server"]
}
