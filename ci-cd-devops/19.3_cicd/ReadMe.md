## 19.3 Процессы CI/CD - Вячеслав Закариев

### Подготовка к выполнению

1. Создайте два VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).
2. Пропишите в [inventory](./infrastructure/inventory/hosts.yml) [playbook](./infrastructure/site.yml) созданные хосты.
3. Добавьте в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе — найдите таску в плейбуке, которая использует id_rsa.pub имя, и исправьте на своё.
4. Запустите playbook, ожидайте успешного завершения.
5. Проверьте готовность SonarQube через [браузер](http://localhost:9000).
6. Зайдите под admin\admin, поменяйте пароль на свой.
7.  Проверьте готовность Nexus через [бразуер](http://localhost:8081).
8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

### Знакомоство с SonarQube

1. Создайте новый проект, название произвольное.
2. Скачайте пакет sonar-scanner, который вам предлагает скачать SonarQube.
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
4. Проверьте `sonar-scanner --version`.
5. Запустите анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`.
6. Посмотрите результат в интерфейсе.
7. Исправьте ошибки, которые он выявил, включая warnings.
8. Запустите анализатор повторно — проверьте, что QG пройдены успешно.
9. Сделайте скриншот успешного прохождения анализа, приложите к решению ДЗ.

### Знакомство с Nexus

1. В репозиторий `maven-public` загрузите артефакт с GAV-параметрами:

 *    groupId: netology;
 *    artifactId: java;
 *    version: 8_282;
 *    classifier: distrib;
 *    type: tar.gz.
   
2. В него же загрузите такой же артефакт, но с version: 8_102.
3. Проверьте, что все файлы загрузились успешно.
4. В ответе пришлите файл `maven-metadata.xml` для этого артефекта.

### Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с [maven](https://maven.apache.org/download.cgi).
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.
4. Проверьте `mvn --version`.
5. Заберите директорию [mvn](./mvn) с pom.

### Основная часть

1. Поменяйте в `pom.xml` блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).
2. Запустите команду `mvn package` в директории с `pom.xml`, ожидайте успешного окончания.
3. Проверьте директорию `~/.m2/repository/`, найдите ваш артефакт.
4. В ответе пришлите исправленный файл `pom.xml`.

---

### Решение №1

1. Инициализировали terraform через VPN
![init](https://github.com/SlavaZakariev/netology/blob/main/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.1.jpg)

2. Подготовлена конфигурация для [terraform](https://github.com/SlavaZakariev/netology/tree/main/ci-cd-devops/19.3_cicd/infrastructure/terraform)

```tf
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
```
3. Развёрнуты ВМ на Yandex Cloud
![VMs](https://github.com/SlavaZakariev/netology/blob/main/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.2.jpg)
![VMs-YC](https://github.com/SlavaZakariev/netology/blob/main/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.3.jpg)

4. Проверена связь с ВМ

**ПРИМЕЧАНИЕ:** Изначально был добавлен ключ ed25519, **ansible** выдавал ошибку прав чтение закрытого ключа, переделал на id_rsa
![ssh](https://github.com/SlavaZakariev/netology/blob/main/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.4.jpg)

5. Запуск Playbook выдаёт ошибку: Не может найти пакет для установки после добавления репозитория PostgeSQL. \
 Что необходимо добавить в Playbook?

```bash
sysadmin@ubuntu1:~/cicd01$ ansible-playbook site.yml -i inventory/hosts.yml

PLAY [Get OpenJDK installed] *************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [sonarqube]

TASK [install unzip] *********************************************************************************************************
ok: [sonarqube]

TASK [Upload .tar.gz file conaining binaries from remote storage] ************************************************************
ok: [sonarqube]

TASK [Ensure installation dir exists] ****************************************************************************************
ok: [sonarqube]

TASK [Extract java in the installation directory] ****************************************************************************
skipping: [sonarqube]

TASK [Export environment variables] ******************************************************************************************
ok: [sonarqube]

PLAY [Get PostgreSQL installed] **********************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [sonarqube]

TASK [Change repo file] ******************************************************************************************************
ok: [sonarqube]

TASK [Install PostgreSQL repos] **********************************************************************************************
ok: [sonarqube]

TASK [Repo update] ***********************************************************************************************************
changed: [sonarqube]

TASK [Install PostgreSQL] ****************************************************************************************************
fatal: [sonarqube]: FAILED! => {"changed": false, "msg": "No package matching 'postgresql11-server' found available, installed or updated", "rc": 126, "results": ["No package matching 'postgresql11-server' found available, installed or updated"]}

PLAY RECAP *******************************************************************************************************************
sonarqube                  : ok=9    changed=1    unreachable=0    failed=1    skipped=1    rescued=0    ignored=0

```





