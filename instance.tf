resource "google_compute_instance" "splunk-server" {
  project      = "cloudjupyter-bhanu"
  name         = "splunk"
  machine_type = "g1-small"
  zone         = "asia-south1-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  tags=["splunk-server"]
  provisioner "remote-exec" {
    connection {
      type    = "ssh"
      user    = "bhanuchandra_sabbavarapu"
      timeout = "120s"
      agent       = false
      private_key = "${file("/home/bhanuchandra_sabbavarapu/.ssh/google_compute_engine")}"
    }
    inline = [
      "sudo apt-get -y install python-minimal"
    ]
  }
}
resource "google_compute_firewall" "http-server" {
  name    = "new-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["splunk-server"]
}
