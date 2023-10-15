## 10.4 Отказоустойчивость в облаке - Вячеслав Закариев

### Задание 1 

Возьмите за основу [решение к заданию 1 из занятия «Подъём инфраструктуры в Яндекс Облаке»](https://github.com/netology-code/sdvps-homeworks/blob/main/7-03.md#задание-1).

1. Теперь вместо одной виртуальной машины сделайте terraform playbook, который:

- создаст 2 идентичные виртуальные машины. Используйте аргумент [count](https://www.terraform.io/docs/language/meta-arguments/count.html) для создания таких ресурсов;
- создаст [таргет-группу](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_target_group). Поместите в неё созданные на шаге 1 виртуальные машины;
- создаст [сетевой балансировщик нагрузки](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer), который слушает на порту 80, отправляет трафик на порт 80 виртуальных машин и http healthcheck на порт 80 виртуальных машин.

Рекомендуем изучить [документацию сетевого балансировщика нагрузки](https://cloud.yandex.ru/docs/network-load-balancer/quickstart) для того, чтобы было понятно, что вы сделали.

2. Установите на созданные виртуальные машины пакет Nginx любым удобным способом и запустите Nginx веб-сервер на порту 80.

3. Перейдите в веб-консоль Yandex Cloud и убедитесь, что: 
- созданный балансировщик находится в статусе Active,
- обе виртуальные машины в целевой группе находятся в состоянии healthy.

4. Сделайте запрос на 80 порт на внешний IP-адрес балансировщика и убедитесь, что вы получаете ответ в виде страницы Nginx.

В качестве результата пришлите:*
1. Terraform Playbook.*
2. Скриншот статуса балансировщика и целевой группы.*
3. Скриншот страницы, которая открылась при запросе IP-адреса балансировщика.*

---

### Решение 1

1. Подготовлена папка проекта **terraform**

![folders](https://github.com/SlavaZakariev/netology/blob/06cf5db1fbf5a829c1ee33dc205c32f617d5c709/fault-tolerance/10.4_fault-tolerance-in-the-cloud/recources/fault_1.1.jpg)

- Приватный ключ **id_ed25519**
- Публичный ключ **id_ed25519.pub**
- Основной конфигурационный файл **terraform main.tf**
- Конфигурационный файл c данными пользователя **meta.yaml**
- Конфигурационный файл обачного провайдера **.terraformrc**

<details>
   <summary> 2. Содержимое main.tf - playbook terraform (OAuth-токен скрыт) </summary>

```terraform
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "y0_AgAAAAAP4jC-AATuwQAAAA___*******"
  cloud_id  = "b1gq162ol42ujjc2mokg"
  folder_id = "b1grcv463u9gm5ihdsn4"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm" {

  count  = 2
  name   = "vm${count.index}"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8g5aftj139tv8u2mo1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.0.0/24"]
}

resource "yandex_lb_target_group" "target-1" {
  name      = "target-1"

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "lb-1"
  listener {
    name = "listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.target-1.id
    healthcheck {
      name = "http"
        http_options {
          port = 80
          path = "/"
        }
    }
  }
}

output "internal_ip_address_vm-0" {
  value = yandex_compute_instance.vm[0].network_interface.0.ip_address
}
output "external_ip_address_vm-0" {
  value = yandex_compute_instance.vm[0].network_interface.0.nat_ip_address
}

output "internal_ip_address_vm-1" {
  value = yandex_compute_instance.vm[1].network_interface.0.ip_address
}
output "external_ip_address_vm-1" {
  value = yandex_compute_instance.vm[1].network_interface.0.nat_ip_address

```
</details>

3. Содержимое файла **meta.yaml** (ssh скрыт)

```yml
#cloud-config
users:
  - name: sysadmin
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINC___******* sysadmin@ubuntu1
```

4. Инициализация terraform (прошла только после включения VPN)

![init](https://github.com/SlavaZakariev/netology/blob/06cf5db1fbf5a829c1ee33dc205c32f617d5c709/fault-tolerance/10.4_fault-tolerance-in-the-cloud/recources/fault_1.2.jpg)

5. IP-адерса вновь созданных ВМ

![vm](https://github.com/SlavaZakariev/netology/blob/06cf5db1fbf5a829c1ee33dc205c32f617d5c709/fault-tolerance/10.4_fault-tolerance-in-the-cloud/recources/fault_1.3.jpg)

6. ВМ в облаке

![yc1](https://github.com/SlavaZakariev/netology/blob/06cf5db1fbf5a829c1ee33dc205c32f617d5c709/fault-tolerance/10.4_fault-tolerance-in-the-cloud/recources/fault_1.4.jpg)

7. Балансировкщик в облаке

![yc2](https://github.com/SlavaZakariev/netology/blob/06cf5db1fbf5a829c1ee33dc205c32f617d5c709/fault-tolerance/10.4_fault-tolerance-in-the-cloud/recources/fault_1.5.jpg)
![yc3](https://github.com/SlavaZakariev/netology/blob/06cf5db1fbf5a829c1ee33dc205c32f617d5c709/fault-tolerance/10.4_fault-tolerance-in-the-cloud/recources/fault_1.6.jpg)

8. Страница nginx при обращении к адресу балансера.

![lb](https://github.com/SlavaZakariev/netology/blob/8052cd2580741510a0465eb5647ee04e733bc1bb/fault-tolerance/10.4_fault-tolerance-in-the-cloud/recources/fault_1.7.jpg)
