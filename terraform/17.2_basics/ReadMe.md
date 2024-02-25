## 17.2 Основы Terraform. "Yandex Cloud" - Вячеслав Закариев

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).

### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

**Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!**

---

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.  Убедитесь что ваша версия **Terraform** =1.5.Х (версия 1.6.Х может вызывать проблемы с Яндекс провайдером) 

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.

---

### Решение 1

1. Установил Yandex Console

![yc](https://github.com/SlavaZakariev/netology/blob/b833328bca00b7deaefdacb7fa4f4a3334d67b32/terraform/17.2_basics/resources/ter_1.1.jpg)

2. Обновил данные в файле **variables.tf**, добавил файл в **.gitignore**.

```terraform
# Local .terraform directories and files
**/.terraform/*
.terraform*

!.terraformrc

# .tfstate files
*.tfstate
*.tfstate.*

# own secret vars store.
personal.auto.tfvars
variables.tf
```
3. Инициализировано облако **terrarorm init**

![init](https://github.com/SlavaZakariev/netology/blob/38792aaab144fbe271dfbea83ecd66a963bfae32/terraform/17.2_basics/resources/ter_1.2.jpg)

4. Исправленный блок кода файа **main.tf** в 15-й и 17-й строке

- Строка `platform_id = "standart-v4"`. Согласно документациии, можно воспользоваться параметрами ЦП: v1, v2 и v3, а также другие графические или высокопроизводительные коды ЦП. В слове **standart** допущена ошибка.
   [https://cloud.yandex.ru/ru/docs/compute/concepts/vm-platforms](https://cloud.yandex.ru/ru/docs/compute/concepts/vm-platforms)
- Строка `cores = 1`. Исправлено количество ядер с 1 до 2, согласно документации 2 ядра является минимальным количеством ядер для виртуальной машины.
   [https://cloud.yandex.ru/ru/docs/compute/concepts/performance-levels](https://cloud.yandex.ru/ru/docs/compute/concepts/performance-levels)

```terraform
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
```
5. Параметр `preemptible = true` применяется при необходимости сделать ВМ прерываемой. Применятся если с момента запуска машины прошло 24 часа, либо возникает нехватка ресурсов для запуска ВМ. Прерываемые ВМ не обеспечивают отказоустойчивость. \
Параметр `core_fraction = 5` указывает базовую производительность ядра в процентах. Применятеся для экономии финансовых затрат на ресурсы в облаке.

6. Созданная ВМ в консоле Yandex Cloud

![ycvm](https://github.com/SlavaZakariev/netology/blob/1fa9547abdbb0d6047330ec0258f3a0bd620ba12/terraform/17.2_basics/resources/ter_1.3.jpg)

7. Подключение по ssh к vm через терминал Windows

![wc](https://github.com/SlavaZakariev/netology/blob/1fa9547abdbb0d6047330ec0258f3a0bd620ba12/terraform/17.2_basics/resources/ter_1.4.jpg)

---

### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

---

### Решение 2

1. Файл **main.tf** состоит из:
   - Сеть VPC и подсеть с ссылкой на переменные
   - Семейство снимка ОС создаваемой ВМ
   - Предоставляемые ресурсы для ВМ (ЦП, ОЗУ, % использования ЦП)
   - Загрузка снимка ОС на диск
   - Параметр прерываемости ВМ
   - Маршрутизация с помощью NAT-инстанса
   - Переменная данных SSH (для аутентификация)
  
2. Добавлены переменные в файл **variables.tf**

```terraform
###vm_web

variable "vm_web_version" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu version"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "instance name"
}

variable "vm_web_cpu_id" {
  type        = string
  default     = "standard-v1"
  description = "cpu id"
}

variable "vm_web_cores" {
  type        = string
  default     = "2"
  description = "numbers of cpu cores"
}

variable "vm_web_memory" {
  type        = string
  default     = "1"
  description = "the amount of RAM"
}

variable "vm_web_core_fraction" {
  type        = string
  default     = "5"
  description = "cpu core fraction"
}

```

3. Внесены изменения в файл **main.tf**

```terraform
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_version
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_cpu_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
```

4. Результат выполнения команды **terraform plan**

![plan](https://github.com/SlavaZakariev/netology/blob/dcdd0dbd51c7b6b6f58cff58aff05304b041f1b8/terraform/17.2_basics/resources/ter_1.5.jpg)

---

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"**, \
   ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf'). \
   ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

---

### Решение 3

1. Создан файл **vms_platform.tf**, подготовлены переменные для новой ВМ **netology-develop-platform-db**

```terraform
###vm_db

variable "vm_db_version" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu version"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "instance name"
}

variable "vm_db_cpu_id" {
  type        = string
  default     = "standard-v1"
  description = "cpu id"
}

variable "vm_db_cores" {
  type        = string
  default     = "2"
  description = "numbers of cpu cores"
}

variable "vm_db_memory" {
  type        = string
  default     = "2"
  description = "the amount of RAM"
}

variable "vm_db_core_fraction" {
  type        = string
  default     = "20"
  description = "cpu core fraction"
}
```

2. Применяем **terraform apply**

![db](https://github.com/SlavaZakariev/netology/blob/3d6beff28e835ae7b44a271cf9e54aa77cf2f94d/terraform/17.2_basics/resources/ter_3.2.jpg)

3. Две ВМ в консоле Yandex Cloud

![db-yc](https://github.com/SlavaZakariev/netology/blob/cb4e35e7935cf606c0e2caa68bac1e5c5a009a40/terraform/17.2_basics/resources/ter_3.1.jpg)

---

### Задание 4

1. Объявите в файле outputs.tf **один** output, содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном вам формате.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

---

### Решение 4

Создан файл **outputs.tf** в папке проекта:

```terraform
output "VMs_data" {
  value = {
    vm_name1 = yandex_compute_instance.platform.name
    fqdn_name1 = yandex_compute_instance.platform.fqdn
    external_ip1 = yandex_compute_instance.platform.network_interface.0.nat_ip_address
    vm_name2 = yandex_compute_instance.platform2.name
    fqdn_name2 = yandex_compute_instance.platform2.fqdn
    external_ip2 = yandex_compute_instance.platform2.network_interface.0.nat_ip_address
 }
}
```
2. Результат вывода файла:

![output](https://github.com/SlavaZakariev/netology/blob/d2f38333ef5bf0b444d868fa3f21250824c3488b/terraform/17.2_basics/resources/ter_4.1.jpg)

---

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

---

### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map.  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=
       memory=
       core_fraction=
       ...
     },
     db= {
       cores=
       memory=
       core_fraction=
       ...
     }
   }
   ```
2. Создайте и используйте отдельную map переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
3. Найдите и закоментируйте все, более не используемые переменные проекта.
4. Проверьте terraform plan. Изменений быть не должно.

---

### Решение 6

1. В файле **variables.tf** добавлена map-переменная для описания ресурсов для ВМ

```terraform
variable "vms_resources" {
  type        = map(map(number))
  default     = {
    vm_web_resources = {
      cores          = 2
      memory         = 1
      core_fraction  = 5
    }
    vm_db_resources = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}
```

2. В файле **variables.tf** добавлена map-переменная для описания SSH для ВМ

```terraform
variable "metadata" {
  type        = map(string)
  default     = {
    serial-port-enable = "1"
    ssh-keys           = "ssh-ed25519 AAAAC___"
 }
}
```
3. Изменения в файле **main.tf**:

web

```terraform
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_version
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_cpu_id
  resources {
    cores         = var.vms_resources.vm_web_resources.cores
    memory        = var.vms_resources.vm_web_resources.memory
    core_fraction = var.vms_resources.vm_web_resources.core_fraction
  }
  metadata = var.metadata
```
db

```terraform
data "yandex_compute_image" "ubuntu-db" {
  family = var.vm_db_version
}
resource "yandex_compute_instance" "platform2" {
  name        = var.vm_db_name
  platform_id = var.vm_db_cpu_id
  resources {
    cores         = var.vms_resources.vm_db_resources.cores
    memory        = var.vms_resources.vm_db_resources.memory
    core_fraction = var.vms_resources.vm_db_resources.core_fraction
  }
  metadata = var.metadata
  
```

5. Результат команды **terraform apply**
  
![apply](https://github.com/SlavaZakariev/netology/blob/a71575729670ff9e90ac40ae4d7d6ed3595d6c0c/terraform/17.2_basics/resources/ter_6.1.jpg)

---

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

---

### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

---

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117"

---

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

### Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

**Важно. Удалите все созданные ресурсы**.

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
