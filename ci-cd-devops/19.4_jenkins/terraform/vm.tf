### ===SonarQube===
data "yandex_compute_image" "centos-jenkins-master" {
  family = var.vm_os_centos
}
resource "yandex_compute_instance" "jenkins-master" {
  name        = var.vm_01
  hostname    = var.vm_01
  platform_id = var.vm_cpu_id_v1
  resources {
    cores         = var.vms_resources.jenkins-master.cores
    memory        = var.vms_resources.jenkins-master.memory
    core_fraction = var.vms_resources.jenkins-master.fraction
  }
  metadata = local.metadata
  scheduling_policy {preemptible = true}
  boot_disk {
  initialize_params {
    image_id = data.yandex_compute_image.centos-jenkins-master.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_ci-cd.id
    nat       = true
    ip_address = "10.10.10.41"
  }
}

### ===Nexus===
data "yandex_compute_image" "centos-jenkins-agent" {
  family = var.vm_os_centos
}
resource "yandex_compute_instance" "jenkins-agent" {
  name        = var.vm_02
  hostname    = var.vm_02
  platform_id = var.vm_cpu_id_v1
  resources {
    cores         = var.vms_resources.jenkins-agent.cores
    memory        = var.vms_resources.jenkins-agent.memory
    core_fraction = var.vms_resources.jenkins-agent.fraction
  }
  metadata = local.metadata
  scheduling_policy {preemptible = true}
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-jenkins-agent.image_id
    }
  }
    network_interface {
    subnet_id = yandex_vpc_subnet.subnet_ci-cd.id
    nat       = true
    ip_address = "10.10.10.42"
  }
}
