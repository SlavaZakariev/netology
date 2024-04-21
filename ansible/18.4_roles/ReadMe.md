## 18.4 Работа с roles - Вячеслав Закариев

### Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

### Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. \
Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. \
Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:
   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```
2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml`.
9. Переработайте playbook на использование roles. Учтите про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Решение 1

1. Инициализировали terraform (через VPN)

![init](https://github.com/SlavaZakariev/netology/blob/19da0d0d5bd4a3ddf812abf8ddd66bb1d944bcb7/ansible/18.4_roles/resources/ans4_1.1.jpg)

2. Подготовлен код terraform

```tf
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
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-clickhouse.image_id
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
```

3. Результат выполнения

![output](https://github.com/SlavaZakariev/netology/blob/19da0d0d5bd4a3ddf812abf8ddd66bb1d944bcb7/ansible/18.4_roles/resources/ans4_1.2.jpg)

4. 
