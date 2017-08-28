variable "secret" {
    default = "some-random-secret-here"
}

module "drone_server" {
    source = "modules/drone_server"
    name = "drone-server"
    ssh_private_key = "~/.ssh/google_compute_engine"
    secret = "${var.secret}"
}

module "drone_agent" {
    source = "modules/drone_agent"
    number = 3
    name = "drone-agent"
    ssh_private_key = "~/.ssh/google_compute_engine"
    server = "${module.drone_server.address}:9000"
    secret = "${var.secret}"
}
