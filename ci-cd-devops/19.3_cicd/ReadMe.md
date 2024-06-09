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

1. Инициализировали **terraform** через **VPN**

![init](https://github.com/SlavaZakariev/netology/blob/928ed33afb8b92884ce628eb8562e41557317e3e/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.1.jpg)

2. Подготовлена конфигурация для [terraform](https://github.com/SlavaZakariev/netology/tree/main/ci-cd-devops/19.3_cicd/terraform)

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
3. Развёрнуты ВМ на **Yandex Cloud**

![yc1](https://github.com/SlavaZakariev/netology/blob/928ed33afb8b92884ce628eb8562e41557317e3e/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.2.jpg)
![yc2](https://github.com/SlavaZakariev/netology/blob/928ed33afb8b92884ce628eb8562e41557317e3e/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.3.jpg)

4. Проверена связь с ВМ

![ping](https://github.com/SlavaZakariev/netology/blob/928ed33afb8b92884ce628eb8562e41557317e3e/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.4.jpg)

**ПРИМЕЧАНИЕ:** Изначально был добавлен ключ **ed25519**, **ansible** выдавал ошибку прав чтение закрытого ключа, переделал на **id_rsa**

5. Запустил **Playbook**.
**ПРИМЕЧАНИЕ:** Внесены изменения в **Playbook** из-за ошибок \
1) Добавлено задание по установке **epel-release** перед заданием установки **PostgreSQL**
2) **PosgreSQL 11** более недоступен из официального репозитория, заменил на **12** версию
3) Изменил путь в задании **Init template1 DB** из-за смены версии **PostgreSQL**
4) Изменил путь при добавлении конфигурационного файла в задании **Copy pg_hba.conf** из-за смены версии **PostgreSQL**
5) Для заданий Configure SonarQube JDBC settings for PostgreSQL и Generate wrapper.conf добавлена строка **become: true**

```bash
sysadmin@ubuntu1:~/cicd03/ansible$ ansible-playbook site.yml -i inventory/hosts.yml

PLAY [Get OpenJDK installed] ************************************************************************************
TASK [Gathering Facts] ******************************************************************************************
ok: [sonarqube]

TASK [install unzip] ********************************************************************************************
ok: [sonarqube]

TASK [Upload .tar.gz file conaining binaries from remote storage] ***********************************************
ok: [sonarqube]

TASK [Ensure installation dir exists] ***************************************************************************
ok: [sonarqube]

TASK [Extract java in the installation directory] ***************************************************************
skipping: [sonarqube]

TASK [Export environment variables] *****************************************************************************
ok: [sonarqube]

PLAY [Get PostgreSQL installed] *********************************************************************************
TASK [Gathering Facts] ******************************************************************************************
ok: [sonarqube]

TASK [Change repo file] *****************************************************************************************
ok: [sonarqube]

TASK [Install PostgreSQL repos] *********************************************************************************
ok: [sonarqube]

TASK [Update cache after added repo] ****************************************************************************
ok: [sonarqube]

TASK [Install epel-release] *************************************************************************************
ok: [sonarqube]

TASK [Install PostgreSQL] ***************************************************************************************
ok: [sonarqube]

TASK [Init template1 DB] ****************************************************************************************
changed: [sonarqube]

TASK [Start pgsql service] **************************************************************************************
ok: [sonarqube]

TASK [Create user in system] ************************************************************************************
ok: [sonarqube]

TASK [Create user for Sonar in PostgreSQL] **********************************************************************
changed: [sonarqube]

TASK [Change password for Sonar user in PostgreSQL] *************************************************************
changed: [sonarqube]

TASK [Create Sonar DB] ******************************************************************************************
changed: [sonarqube]

TASK [Copy pg_hba.conf] *****************************************************************************************
ok: [sonarqube]

PLAY [Prepare Sonar host] ***************************************************************************************
TASK [Gathering Facts] ******************************************************************************************
ok: [sonarqube]

TASK [Create group in system] ***********************************************************************************
ok: [sonarqube]

TASK [Create user in system] ************************************************************************************
ok: [sonarqube]

TASK [Set up ssh key to access for managed node] ****************************************************************
ok: [sonarqube]

TASK [Allow group to have passwordless sudo] ********************************************************************
ok: [sonarqube]

TASK [Increase Virtual Memory] **********************************************************************************
ok: [sonarqube]

TASK [Reboot VM] ************************************************************************************************
changed: [sonarqube]

PLAY [Get Sonarqube installed] **********************************************************************************
TASK [Gathering Facts] ******************************************************************************************
ok: [sonarqube]

TASK [Get distrib ZIP] ******************************************************************************************
ok: [sonarqube]

TASK [Unzip Sonar] **********************************************************************************************
skipping: [sonarqube]

TASK [Move Sonar into place.] ***********************************************************************************
changed: [sonarqube]

TASK [Configure SonarQube JDBC settings for PostgreSQL.] ********************************************************
changed: [sonarqube] => (item={'regexp': '^sonar.jdbc.username', 'line': 'sonar.jdbc.username=sonar'})
changed: [sonarqube] => (item={'regexp': '^sonar.jdbc.password', 'line': 'sonar.jdbc.password=sonar'})
changed: [sonarqube] => (item={'regexp': '^sonar.jdbc.url', 'line': 'sonar.jdbc.url=jdbc:postgresql://localhost:
5432/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance'})
changed: [sonarqube] => (item={'regexp': '^sonar.web.context', 'line': 'sonar.web.context='})

TASK [Generate wrapper.conf] ************************************************************************************
changed: [sonarqube]

TASK [Symlink sonar bin.] ***************************************************************************************
ok: [sonarqube]

TASK [Copy SonarQube systemd unit file into place (for systemd systems).] ***************************************
ok: [sonarqube]

TASK [Ensure Sonar is running and set to start on boot.] ********************************************************
changed: [sonarqube]

TASK [Allow Sonar time to build on first start.] ****************************************************************
skipping: [sonarqube]

TASK [Make sure Sonar is responding on the configured port.] ****************************************************
ok: [sonarqube]

PLAY [Get Nexus installed] **************************************************************************************
TASK [Gathering Facts] ******************************************************************************************
ok: [nexus]

TASK [Create Nexus group] ***************************************************************************************
ok: [nexus]

TASK [Create Nexus user] ****************************************************************************************
ok: [nexus]

TASK [Install JDK] **********************************************************************************************
ok: [nexus]

TASK [Create Nexus directories] *********************************************************************************
ok: [nexus] => (item=/home/nexus/log)
ok: [nexus] => (item=/home/nexus/sonatype-work/nexus3)
ok: [nexus] => (item=/home/nexus/sonatype-work/nexus3/etc)
ok: [nexus] => (item=/home/nexus/pkg)
ok: [nexus] => (item=/home/nexus/tmp)

TASK [Download Nexus] *******************************************************************************************
changed: [nexus]

TASK [Unpack Nexus] *********************************************************************************************
changed: [nexus]

TASK [Link to Nexus Directory] **********************************************************************************
changed: [nexus]

TASK [Add NEXUS_HOME for Nexus user] ****************************************************************************
changed: [nexus]

TASK [Add run_as_user to Nexus.rc] ******************************************************************************
changed: [nexus]

TASK [Raise nofile limit for Nexus user] ************************************************************************
changed: [nexus]

TASK [Create Nexus service for SystemD] *************************************************************************
changed: [nexus]

TASK [Ensure Nexus service is enabled for SystemD] **************************************************************
changed: [nexus]

TASK [Create Nexus vmoptions] ***********************************************************************************
changed: [nexus]

TASK [Create Nexus properties] **********************************************************************************
changed: [nexus]

TASK [Lower Nexus disk space threshold] *************************************************************************
skipping: [nexus]

TASK [Start Nexus service if enabled] ***************************************************************************
changed: [nexus]

TASK [Ensure Nexus service is restarted] ************************************************************************
skipping: [nexus]

TASK [Wait for Nexus port if started] ***************************************************************************
ok: [nexus]

PLAY RECAP ******************************************************************************************************
nexus                      : ok=17   changed=11   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
sonarqube                  : ok=34   changed=9    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

```





