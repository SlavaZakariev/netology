data "yandex_compute_image" "ubuntu1" {
  family = var.vm_ubuntu_ver
}

resource "yandex_compute_instance" "count" {
  count = 2
  name = "web-${count.index+1}"
  platform_id = var.vm_cpu_id
  zone        = var.default_zone
  resources {
    cores         = var.vms_resources.vm_count_resources.cores
    memory        = var.vms_resources.vm_count_resources.memory
    core_fraction = var.vms_resources.vm_count_resources.core_fraction
  }
    
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu1.image_id
   }
  }

  network_interface {
    security_group_ids = [yandex_vpc_security_group.example.id]    
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
  }

  scheduling_policy {preemptible = true}
  
  metadata = local.metadata
}
