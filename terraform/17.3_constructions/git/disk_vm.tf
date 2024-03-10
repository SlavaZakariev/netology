data "yandex_compute_image" "storage" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_disk" "disks" {
  count = 3
  name  = "disk-${count.index+1}"
  type  = "network-hdd"
  size  = 1
  block_size = 4096
}

resource "yandex_compute_instance" "storage" {  
  name        = "storage"
  zone        = "ru-central1-a"
  platform_id = "standard-v1"
   
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5 
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.storage.image_id
      type = "network-hdd"
      size = 5
    }   
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks.*.id
    content {
      disk_id = secondary_disk.value
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  scheduling_policy {preemptible = true}
  
  metadata = local.metadata
}
