### ===SonarQube===
data "yandex_compute_image" "centos-sonarqube" {
  family = var.vm_os_centos
}
resource "yandex_compute_instance" "sonarqube" {
  name        = var.vm_01
  hostname    = var.vm_01
  platform_id = var.vm_cpu_id_v1
  resources {
    cores         = var.vms_resources.sonarqube.cores
    memory        = var.vms_resources.sonarqube.memory
    core_fraction = var.vms_resources.sonarqube.fraction
  }
  metadata = local.metadata
  scheduling_policy {preemptible = true}
  boot_disk {
  initialize_params {
    image_id = data.yandex_compute_image.centos-sonarqube.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_ci-cd.id
    nat       = true
    ip_address = "10.10.10.11"
  }
}

### ===Nexus===
data "yandex_compute_image" "centos-nexus" {
  family = var.vm_os_centos
}
resource "yandex_compute_instance" "nexus" {
  name        = var.vm_02
  hostname    = var.vm_02
  platform_id = var.vm_cpu_id_v1
  resources {
    cores         = var.vms_resources.nexus.cores
    memory        = var.vms_resources.nexus.memory
    core_fraction = var.vms_resources.nexus.fraction
  }
  metadata = local.metadata
  scheduling_policy {preemptible = true}
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-nexus.image_id
    }
  }
    network_interface {
    subnet_id = yandex_vpc_subnet.subnet_ci-cd.id
    nat       = true
    ip_address = "10.10.10.12"
  }
}
