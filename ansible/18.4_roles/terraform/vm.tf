### ===clickhouse===
data "yandex_compute_image" "ubuntu-clickhouse" {
  family = var.vm_os_ubuntu
}

resource "yandex_compute_instance" "clickhouse" {
  name        = var.vm_01
  hostname    = var.vm_01
  platform_id = var.vm_cpu_id_v1
  resources {
    cores         = var.vms_resources.clickhouse.cores
    memory        = var.vms_resources.clickhouse.memory
    core_fraction = var.vms_resources.clickhouse.fraction
  }

  metadata = local.metadata

#  metadata = {
#    ssh-keys           = var.metadata.ssh-keys
#    serial-port-enable = var.metadata.serial-port-enable
#  }

  #  metadata = {
  #    user-data = templatefile("metadata.yaml", {
  #      USER_NAME    = var.user_name
  #      USER_SSH_KEY = var.user_ssh_key
  #    })
  #  }

#  metadata = {
#    user-data = "#cloud-config\nusers:\n  - name: <имя_пользователя>\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=        (ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - <содержимое_SSH-ключа>"
#  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-clickhouse.image_id
#      name        = "disk-clickhouse-1"
#      type        = "network-nvme"
#      size        = "10"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet_db.id
    nat        = true
    ip_address = "10.10.10.11"
  }
}

### ===vector===
data "yandex_compute_image" "ubuntu-vector" {
  family = var.vm_os_ubuntu
}

resource "yandex_compute_instance" "vector" {
  name        = var.vm_02
  hostname    = var.vm_02
  platform_id = var.vm_cpu_id_v1
  resources {
    cores         = var.vms_resources.vector.cores
    memory        = var.vms_resources.vector.memory
    core_fraction = var.vms_resources.vector.fraction
  }

  metadata = local.metadata

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-vector.image_id
      #      disk_id = yandex_compute_disk.disk-vector.id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet_db.id
    nat        = true
    ip_address = "10.10.10.12"
  }
}

### ===lighthouse===
data "yandex_compute_image" "ubuntu-lighthouse" {
  family = var.vm_os_ubuntu
}

resource "yandex_compute_instance" "lighthouse" {
  name        = var.vm_03
  hostname    = var.vm_03
  platform_id = var.vm_cpu_id_v1
  resources {
    cores         = var.vms_resources.lighthouse.cores
    memory        = var.vms_resources.lighthouse.memory
    core_fraction = var.vms_resources.lighthouse.fraction
  }

  metadata = local.metadata

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-lighthouse.image_id
      #      disk_id = yandex_compute_disk.disk-lighthouse.id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet_db.id
    nat        = true
    ip_address = "10.10.10.13"
  }
}
