resource  "local_file" "inventory" {
  filename = "${abspath(path.module)}/hosts.cfg"
  content  = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.count
    databases  = yandex_compute_instance.for_each
    storage   = [yandex_compute_instance.storage]
    })  
 }
