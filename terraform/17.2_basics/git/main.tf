### VPC
resource "yandex_vpc_network" "web" {
  name = var.vpc_nameweb
}
resource "yandex_vpc_subnet" "web_subnet" {
  name           = var.subnet_nameweb
  zone           = var.zone_a
  network_id     = yandex_vpc_network.web.id
  v4_cidr_blocks = var.cidr_a
}

resource "yandex_vpc_network" "db" {
  name = var.vpc_namedb
}
resource "yandex_vpc_subnet" "db_subnet" {
  name           = var.subnet_namedb
  zone           = var.zone_b
  network_id     = yandex_vpc_network.db.id
  v4_cidr_blocks = var.cidr_b
}

### VMs
data "yandex_compute_image" "ubuntu-web" {
  family = var.vm_web_version
}
resource "yandex_compute_instance" "web" {
  name        = local.vm_web
  platform_id = var.vm_web_cpu_id
  resources {
    cores         = var.vms_resources.vm_web_resources.cores
    memory        = var.vms_resources.vm_web_resources.memory
    core_fraction = var.vms_resources.vm_web_resources.core_fraction
  }
  metadata = var.metadata
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-web.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.web_subnet.id
    nat       = true
  }
}

data "yandex_compute_image" "ubuntu-db" {
  family = var.vm_db_version
}
resource "yandex_compute_instance" "db" {
  name        = local.vm_db
  platform_id = var.vm_db_cpu_id
  resources {
    cores         = var.vms_resources.vm_db_resources.cores
    memory        = var.vms_resources.vm_db_resources.memory
    core_fraction = var.vms_resources.vm_db_resources.core_fraction
  }
  metadata = var.metadata
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-db.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.db_subnet.id
    nat       = true
  }
}
