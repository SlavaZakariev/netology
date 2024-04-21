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

1. Инициализировал **terraform** (через VPN)

![init](https://github.com/SlavaZakariev/netology/blob/19da0d0d5bd4a3ddf812abf8ddd66bb1d944bcb7/ansible/18.4_roles/resources/ans4_1.1.jpg)

2. Подготовлен код [terraform](https://github.com/SlavaZakariev/netology/tree/main/ansible/18.4_roles/terraform)

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
![yc](https://github.com/SlavaZakariev/netology/blob/19da0d0d5bd4a3ddf812abf8ddd66bb1d944bcb7/ansible/18.4_roles/resources/ans4_1.3.jpg)

4. Добавление ролей

![roles](https://github.com/SlavaZakariev/netology/blob/19da0d0d5bd4a3ddf812abf8ddd66bb1d944bcb7/ansible/18.4_roles/resources/ans4_1.4.jpg)

5. Выполнение playbook `ansible-playbook -i inventory/prod.yml site.yml`

```
ansible-playbook -i inventory/prod.yml site.yml

PLAY [Install Clickhouse] ****************************************************************************************************
TASK [Gathering Facts] *******************************************************************************************************
ok: [clickhouse]

TASK [clickhouse : Include OS Family Specific Variables] *********************************************************************
ok: [clickhouse]

TASK [clickhouse : Requirements check | Checking sse4_2 support] *************************************************************
ok: [clickhouse]

TASK [clickhouse : Requirements check | Not supported distribution && release] ***********************************************
skipping: [clickhouse]

TASK [clickhouse : Set clickhouse_service_enable] ****************************************************************************
ok: [clickhouse]

TASK [clickhouse : Set clickhouse_service_ensure] ****************************************************************************
ok: [clickhouse]

TASK [clickhouse : Install | Ensure clickhouse repo GPG key imported] ********************************************************
changed: [clickhouse]

TASK [clickhouse : Install | Ensure clickhouse repo installed] ***************************************************************
changed: [clickhouse]

TASK [clickhouse : Install | Ensure clickhouse package installed (latest)] ***************************************************
skipping: [clickhouse]

TASK [clickhouse : Install | Ensure clickhouse package installed (version 22.3.3.44)] ****************************************
changed: [clickhouse]

TASK [clickhouse : Check clickhouse config, data and logs] *******************************************************************
ok: [clickhouse] => (item=/var/log/clickhouse-server)
changed: [clickhouse] => (item=/etc/clickhouse-server)
changed: [clickhouse] => (item=/var/lib/clickhouse/tmp/)
changed: [clickhouse] => (item=/var/lib/clickhouse/)

TASK [clickhouse : Config | Create config.d folder] **************************************************************************
changed: [clickhouse]

TASK [clickhouse : Config | Create users.d folder] ***************************************************************************
changed: [clickhouse]

TASK [clickhouse : Config | Generate system config] **************************************************************************
changed: [clickhouse]

TASK [clickhouse : Config | Generate users config] ***************************************************************************
changed: [clickhouse]

TASK [clickhouse : Config | Generate remote_servers config] ******************************************************************
skipping: [clickhouse]

TASK [clickhouse : Config | Generate macros config] **************************************************************************
skipping: [clickhouse]

TASK [clickhouse : Config | Generate zookeeper servers config] ***************************************************************
skipping: [clickhouse]

TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] ***********************************
skipping: [clickhouse]

TASK [clickhouse : Notify Handlers Now] **************************************************************************************

RUNNING HANDLER [clickhouse : Restart Clickhouse Service] ********************************************************************
ok: [clickhouse]

TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: restarted] ***********************************
changed: [clickhouse]

TASK [clickhouse : Wait for Clickhouse Server to Become Ready] ***************************************************************
ok: [clickhouse]

TASK [clickhouse : Set ClickHose Connection String] **************************************************************************
ok: [clickhouse]

TASK [clickhouse : Gather list of existing databases] ************************************************************************
ok: [clickhouse]

TASK [clickhouse : Config | Delete database config] **************************************************************************

TASK [clickhouse : Config | Create database config] **************************************************************************

TASK [clickhouse : Config | Generate dictionary config] **********************************************************************
skipping: [clickhouse]

TASK [clickhouse : include_tasks] ********************************************************************************************
skipping: [clickhouse]

PLAY [Install Lighthouse] ****************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [lighthouse]

TASK [lighthouse : NGINX | Install epel-release] *****************************************************************************
changed: [lighthouse]

TASK [lighthouse : NGINX | Install NGINX] ************************************************************************************
changed: [lighthouse]

TASK [lighthouse : NGINX | Create Config] ************************************************************************************
changed: [lighthouse]

TASK [lighthouse : Lighthouse | Create lighthouse vector_config] *************************************************************
changed: [lighthouse]

RUNNING HANDLER [lighthouse : start-nginx] ***********************************************************************************
changed: [lighthouse]

RUNNING HANDLER [lighthouse : reload-nginx] **********************************************************************************
changed: [lighthouse]

PLAY [Install Vector] ********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [vector]

TASK [vector : Install Vector] ***********************************************************************************************
changed: [vector]

TASK [vector : Configure Vector] 
******************************************************************************************************************************
changed: [vector]

TASK [vector : Vector | Create systemd unit] *********************************************************************************
changed: [vector]

TASK [vector : Vector | Start Service] ***************************************************************************************
changed: [vector]

PLAY RECAP *******************************************************************************************************************
clickhouse              : ok=25   changed=9    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0
lighthouse              : ok=9    changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector                  : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
