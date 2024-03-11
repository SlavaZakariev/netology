## 17.3 Управляющие конструкции в коде Terraform - Вячеслав Закариев

### Цели задания

1. Отработать основные принципы и методы работы с управляющими конструкциями Terraform.
2. Освоить работу с шаблонизатором Terraform (Interpolation Syntax).

---

### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Доступен исходный код для выполнения задания в директории [**03/src**](https://github.com/netology-code/ter-homeworks/tree/main/03/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

**Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!**

---

### Задание 1

1. Изучите проект.
2. Заполните файл personal.auto.tfvars.
3. Инициализируйте проект, выполните код. Он выполнится, даже если доступа к preview нет.

Примечание. Если у вас не активирован preview-доступ к функционалу «Группы безопасности» в Yandex Cloud, запросите доступ у поддержки облачного провайдера. Обычно его выдают в течение 24-х часов.

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.

---

Решение 1

1. Инициализация проекта

![init](https://github.com/SlavaZakariev/netology/blob/52bcb5550cb5a9f1b08db2035a8807932a5854b8/terraform/17.3_constructions/resources/ter2_1.1.jpg)

2. Группа безопасности **example_dynamic**

![security](https://github.com/SlavaZakariev/netology/blob/52bcb5550cb5a9f1b08db2035a8807932a5854b8/terraform/17.3_constructions/resources/ter2_1.2.jpg)

---

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" **разных** по cpu/ram/disk_volume , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа:
```
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
}
```  
3. При желании внесите в переменную все возможные параметры.
4. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.
5. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
6. Инициализируйте проект, выполните код.

---

### Решение 2

1. Создан файл **count-vm.tf**

```terraform
data "yandex_compute_image" "ubuntu1" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "count" {
    count = 2
    name = "web-${count.index+1}"
    platform_id = "standard-v1"
    resources {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    
    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu1.image_id
    }
  }

  network_interface {
    security_group_ids = [yandex_vpc_security_group.example.id]    
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  scheduling_policy {preemptible = true}
  
  metadata = local.metadata
}
```

2. Создан файл **for_each-vm.tf**, описал переменные внутри данного файла.

```terraform
data "yandex_compute_image" "ubuntu2" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "for_each" {
  depends_on  = [yandex_compute_instance.count]
  for_each    = var.vm_resources
  name        = each.value.vm_name
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
  resources {
    cores      = each.value.cores
    memory     = each.value.memory
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
    cores     = number
    memory    = number
    disk      = number
  }))
  default = {
    main    = { vm_name = "main", cores = 2, memory = 2, disk = 5 }
    replica = { vm_name = "replica", cores = 4, memory = 4, disk = 10 }
  }
}
```

3. Создан файл **locals.tf** с данными ключа.

```terraform
locals {
  metadata = {  
    serial-port-enable = 1
    ssh-keys = "metadata:${file("~/.ssh/id_ed25519.pub")}"
 }
}
```
4. Результат выполнения команды **terraform apply**

![apply](https://github.com/SlavaZakariev/netology/blob/70920aeeda1c61465600130f6f5087643f3e8d1c/terraform/17.3_constructions/resources/ter2_2.1.jpg)

5. Результат в консоли **Yandex Cloud**

![yc](https://github.com/SlavaZakariev/netology/blob/70920aeeda1c61465600130f6f5087643f3e8d1c/terraform/17.3_constructions/resources/ter2_2.2.jpg)

---

### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf**.
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage". Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

---

### Решение 3

1. Создан файл **disk_vm.tf**

```terraform
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
```
2. Результат выполнения команды **terraform apply**

![apply2](https://github.com/SlavaZakariev/netology/blob/571726a98010e6280d512ffef9f7dbd6b954fb10/terraform/17.3_constructions/resources/ter2_3.1.jpg)

3. Созданный ресурс в консоли **Yandex Cloud**

![apply2](https://github.com/SlavaZakariev/netology/blob/571726a98010e6280d512ffef9f7dbd6b954fb10/terraform/17.3_constructions/resources/ter2_3.2.jpg)

---

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Добавьте в инвентарь переменную  [**fqdn**](https://cloud.yandex.ru/docs/compute/concepts/network#hostname).
``` 
[webservers]
web-1 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
web-2 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[databases]
main ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
replica ansible_host<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[storage]
storage ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
```
Пример fqdn: ```web1.ru-central1.internal```(в случае указания имени ВМ); ```fhm8k1oojmm5lie8i22a.auto.internal```(в случае автоматической генерации имени ВМ зона изменяется). нужную вам переменную найдите в документации провайдера или terraform console.
4. Выполните код. Приложите скриншот получившегося файла. 

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

---

### Решение 4

1. Создан файл **ansible.tf**

```terraform
resource  "local_file" "inventory" {
  filename = "${abspath(path.module)}/hosts.cfg"
  content  = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.count
    databases  = yandex_compute_instance.for_each
    storage   = [yandex_compute_instance.storage]
    })  
 }
```

2. Создан **hosts.tftpl** в папке проета

```bash
[webservers]
%{~ for i in webservers ~}
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]==null ? i["network_interface"][0]["ip_address"] : i["network_interface"][0]["nat_ip_address"]}
%{~ endfor ~}

[databases]
%{~ for i in databases ~}
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]==null ? i["network_interface"][0]["ip_address"] : i["network_interface"][0]["nat_ip_address"]}
%{~ endfor ~}

[storage]
%{~ for i in storage ~}
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]==null ? i["network_interface"][0]["ip_address"] : i["network_interface"][0]["nat_ip_address"]}
%{~ endfor ~}
```

3. Результат выполнения команды **terraform apply**

![ansible](https://github.com/SlavaZakariev/netology/blob/b1792f62d33da56e59eb6dceb7bf1c7a5900389f/terraform/17.3_constructions/resources/ter2_4.1.jpg)

4. В результате в папке проекта появился файл **host.cfg**

![host](https://github.com/SlavaZakariev/netology/blob/dcdd5191290131bbfe83b4d393155e3181956fae/terraform/17.3_constructions/resources/ter2_4.3.jpg)

5. Пересобрались виртуальные машины в **Yandex Cloud**

![host](https://github.com/SlavaZakariev/netology/blob/dcdd5191290131bbfe83b4d393155e3181956fae/terraform/17.3_constructions/resources/ter2_4.2.jpg)

---

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 5* (необязательное)
1. Напишите output, который отобразит ВМ из ваших ресурсов count и for_each в виде списка словарей :
``` 
[
 {
  "name" = 'имя ВМ1'
  "id"   = 'идентификатор ВМ1'
  "fqdn" = 'Внутренний FQDN ВМ1'
 },
 {
  "name" = 'имя ВМ2'
  "id"   = 'идентификатор ВМ2'
  "fqdn" = 'Внутренний FQDN ВМ2'
 },
 ....
...итд любое количество ВМ в ресурсе(те требуется итерация по ресурсам, а не хардкод) !!!!!!!!!!!!!!!!!!!!!
]
```
Приложите скриншот вывода команды ```terrafrom output```.

---

### Задание 6* (необязательное)

1. Используя null_resource и local-exec, примените ansible-playbook к ВМ из ansible inventory-файла.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
3. Модифицируйте файл-шаблон hosts.tftpl. Необходимо отредактировать переменную ```ansible_host="<внешний IP-address или внутренний IP-address если у ВМ отсутвует внешний адрес>```.

Для проверки работы уберите у ВМ внешние адреса(nat=false). Этот вариант используется при работе через bastion-сервер.
Для зачёта предоставьте код вместе с основной частью задания.

### Правила приёма работы

В своём git-репозитории создайте новую ветку terraform-03, закоммитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-03.

В качестве результата прикрепите ссылку на ветку terraform-03 в вашем репозитории.

Важно. Удалите все созданные ресурсы.
