data "yandex_compute_image" "ubuntu2" {
  family = var.vm_ubuntu_ver
}

resource "yandex_compute_instance" "for_each" {
  depends_on  = [yandex_compute_instance.count]
  for_each    = var.vm_resources
  name        = each.value.vm_name
  platform_id = var.vm_cpu_id
  zone        = var.default_zone
  resources {
    cores     = each.value.cores
    memory    = each.value.memory
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu2.image_id
   }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  scheduling_policy {preemptible = true}

  metadata = local.metadata
}

variable "vm_resources" {
  type = map(object({
    vm_name = string
    cores   = number
    memory  = number
    disk    = number
  }))
  default = {
    main    = { vm_name = "main", cores = 2, memory = 2, disk = 5 }
    replica = { vm_name = "replica", cores = 4, memory = 4, disk = 10 }
  }
}
