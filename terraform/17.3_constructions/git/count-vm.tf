data "yandex_compute_image" "ubuntu1" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "count" {
    count = 2
    name = "web-${count.index+1}"
    platform_id = "standard-v1"
    resources {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    
    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu1.image_id
    }
  }

  network_interface {
    security_group_ids = [yandex_vpc_security_group.example.id]    
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  scheduling_policy {preemptible = true}
  
  metadata = local.metadata
}
