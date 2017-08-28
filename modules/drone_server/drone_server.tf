variable "name" {
    description = "Base name for each instance"
}

variable "ssh_private_key" {
    description = "Private SSH key to connect to each instance"
}

variable "secret" {
    description = "Random secret used internally by Drone"
}

variable "machine_type" {
    default = "f1-micro"
    description = "Machine type for each instance"
}

variable "disk_size" {
    default = 20
    description = "Disk size in GB for each instance"
}

resource "google_compute_address" "server" {
    name = "drone-server"
}

data "template_file" "server_setup" {
    template = "${file("${path.module}/setup.bash.tpl")}"

    vars {
        url = "http://${google_compute_address.server.address}"
        secret = "${var.secret}"
    }
}

resource "google_compute_instance" "server" {
    count = 1
    name  = "${var.name}"
    machine_type = "${var.machine_type}"
    zone = "us-west1-a"
    tags = ["drone-server"]

    boot_disk {
        initialize_params {
            image = "ubuntu-1604-lts"
            type = "pd-ssd"
            size = "${var.disk_size}"
        }
        auto_delete = true
    }

    network_interface {
        network = "default"
        access_config {
            nat_ip = "${google_compute_address.server.address}"
        }
    }

    scheduling {
        preemptible = false
        on_host_maintenance = "MIGRATE"
        automatic_restart = true
    }

    provisioner "remote-exec" {
        inline = [
            "${data.template_file.server_setup.rendered}"
        ]
        connection {
            type = "ssh"
            user = "ubuntu",
            private_key = "${file(var.ssh_private_key)}"
        }
    }
}

output "address" {
    value = "${google_compute_address.server.address}"
}
