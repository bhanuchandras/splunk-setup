data "template_file" "test" {
  template = "${file("./hosts.tpl")}"
  vars {
   master-ip = "${google_compute_instance.splunk-server.network_interface.0.access_config.0.nat_ip}"
  }
}
resource "null_resource" "export_rendered_template" {
provisioner "local-exec" {
    command = "cat >host.json <<EOL\n${data.template_file.test.rendered}\nEOL"
  }
}
