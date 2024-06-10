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
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH).
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
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH).
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

**ПРИМЕЧАНИЕ:** Изначально был добавлен ключ **ed25519**, **ansible** выдавал ошибку прав чтение закрытого ключа, переделал на **id_rsa**

![ping](https://github.com/SlavaZakariev/netology/blob/928ed33afb8b92884ce628eb8562e41557317e3e/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.4.jpg)

5. Запустил **Playbook**.

**ПРИМЕЧАНИЕ:** Внесены изменения в **Playbook** из-за ошибок
1) Добавлено задание по установке **epel-release** перед заданием установки **PostgreSQL**
2) **PosgreSQL 11** более недоступен из официального репозитория, заменил на **12** версию
3) Изменил путь в задании **Init template1 DB** из-за смены версии **PostgreSQL**
4) Изменил путь при добавлении конфигурационного файла в задании **Copy pg_hba.conf** из-за смены версии **PostgreSQL**
5) Для заданий **Configure SonarQube JDBC settings for PostgreSQL** и **Generate wrapper.conf** добавлена строка **become: true**

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

6. Проверка доступности и смена пароля на **SonarQube**

![sonarpass](https://github.com/SlavaZakariev/netology/blob/6adbebdf67394ebea42a0b6d9c02cc319f0b3d53/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.5.jpg)

7. Проверка доступности и смена пароля на **Nexus**

![nexuspass](https://github.com/SlavaZakariev/netology/blob/6adbebdf67394ebea42a0b6d9c02cc319f0b3d53/ci-cd-devops/19.3_cicd/resources/ci-cd3_1.6.jpg)

8. Скачали архив, распаковали и добавили бинарный файл по пути **/opt/sonar-scanner**, добавили переменную в **$PATH**

9. Проверка версии socar-scanner

```shell
[centos@sonarqube ~]$ sonar-scanner --version
19:44:54.198 INFO  Scanner configuration file: /opt/sonar-scanner/conf/sonar-scanner.properties
19:44:54.204 INFO  Project root configuration file: NONE
19:44:54.227 INFO  SonarScanner CLI 6.0.0.4432
19:44:54.231 INFO  Java 17.0.11 Eclipse Adoptium (64-bit)
19:44:54.235 INFO  Linux 3.10.0-1160.118.1.el7.x86_64 amd64
```
10. Запуск кода с ключом

<details>
<summary>Результат в терминале</summary>

```shell
[centos@sonarqube ~]$ sonar-scanner \
>   -Dsonar.projectKey=Netology \
>   -Dsonar.sources=. \
>   -Dsonar.host.url=http://130.193.37.99:9000 \
>   -Dsonar.login=6a913462dd51e6511f4bd7910d89e09c48e542ae
>   -Dsonar.coverage.exclusions=fail.py
20:41:17.835 INFO  Scanner configuration file: /opt/sonar-scanner/conf/sonar-scanner.properties
20:41:17.840 INFO  Project root configuration file: NONE
20:41:17.869 INFO  SonarScanner CLI 6.0.0.4432
20:41:17.874 INFO  Java 17.0.11 Eclipse Adoptium (64-bit)
20:41:17.875 INFO  Linux 3.10.0-1160.118.1.el7.x86_64 amd64
20:41:17.937 INFO  User cache: /home/centos/.sonar/cache
20:41:19.570 INFO  Communicating with SonarQube Server 9.1.0.47736
20:41:19.924 INFO  Load global settings
20:41:20.044 INFO  Load global settings (done) | time=122ms
20:41:20.049 INFO  Server id: 9CFC3560-AY_9gzuRvZpl2HUI33CH
20:41:20.053 INFO  User cache: /home/centos/.sonar/cache
20:41:20.056 INFO  Load/download plugins
20:41:20.057 INFO  Load plugins index
20:41:20.134 INFO  Load plugins index (done) | time=77ms
20:41:21.821 INFO  Load/download plugins (done) | time=1765ms
20:41:22.460 INFO  Process project properties
20:41:22.470 INFO  Process project properties (done) | time=10ms
20:41:22.471 INFO  Execute project builders
20:41:22.473 INFO  Execute project builders (done) | time=2ms
20:41:22.479 INFO  Project key: Netology
20:41:22.479 INFO  Base dir: /home/centos
20:41:22.479 INFO  Working dir: /home/centos/.scannerwork
20:41:22.731 INFO  Load project settings for component key: 'Netology'
20:41:22.831 INFO  Load project settings for component key: 'Netology' (done) | time=100ms
20:41:22.953 INFO  Load quality profiles
20:41:23.776 INFO  Load quality profiles (done) | time=823ms
20:41:23.809 INFO  Load active rules
20:41:28.872 INFO  Load active rules (done) | time=5063ms
20:41:28.901 WARN  SCM provider autodetection failed. Please use "sonar.scm.provider" to define SCM of your project,
or disable the SCM Sensor in the project settings.
20:41:28.948 INFO  Indexing files...
20:41:28.949 INFO  Project configuration:
20:41:28.986 INFO  2 files indexed
20:41:28.987 INFO  Quality profile for py: Sonar way
20:41:28.987 INFO  ------------- Run sensors on module Netology
20:41:29.144 INFO  Load metrics repository
20:41:29.212 INFO  Load metrics repository (done) | time=68ms
20:41:30.516 INFO  Sensor Python Sensor [python]
20:41:30.521 WARN  Your code is analyzed as compatible with python 2 and 3 by default.
This will prevent the detection of issues specific to python 2 or python 3.
You can get a more precise analysis by setting a python version in your configuration via the parameter "sonar.python.version"
20:41:30.529 INFO  Starting global symbols computation
20:41:30.540 INFO  Load project repositories
20:41:30.544 INFO  1 source file to be analyzed
20:41:30.998 INFO  Load project repositories (done) | time=458ms
20:41:31.414 INFO  1/1 source file has been analyzed
20:41:31.414 INFO  Starting rules execution
20:41:31.425 INFO  1 source file to be analyzed
20:41:31.866 INFO  1/1 source file has been analyzed
20:41:31.867 INFO  Sensor Python Sensor [python] (done) | time=1351ms
20:41:31.867 INFO  Sensor Cobertura Sensor for Python coverage [python]
20:41:31.883 INFO  Sensor Cobertura Sensor for Python coverage [python] (done) | time=16ms
20:41:31.883 INFO  Sensor PythonXUnitSensor [python]
20:41:31.885 INFO  Sensor PythonXUnitSensor [python] (done) | time=2ms
20:41:31.885 INFO  Sensor CSS Rules [cssfamily]
20:41:31.889 INFO  No CSS, PHP, HTML or VueJS files are found in the project. CSS analysis is skipped.
20:41:31.889 INFO  Sensor CSS Rules [cssfamily] (done) | time=4ms
20:41:31.889 INFO  Sensor JaCoCo XML Report Importer [jacoco]
20:41:31.891 INFO  'sonar.coverage.jacoco.xmlReportPaths' is not defined. Using default locations:
target/site/jacoco/jacoco.xml,target/site/jacoco-it/jacoco.xml,build/reports/jacoco/test/jacocoTestReport.xml
20:41:31.892 INFO  No report imported, no coverage information will be imported by JaCoCo XML Report Importer
20:41:31.892 INFO  Sensor JaCoCo XML Report Importer [jacoco] (done) | time=3ms
20:41:31.892 INFO  Sensor C# Project Type Information [csharp]
20:41:31.893 INFO  Sensor C# Project Type Information [csharp] (done) | time=1ms
20:41:31.893 INFO  Sensor C# Analysis Log [csharp]
20:41:31.905 INFO  Sensor C# Analysis Log [csharp] (done) | time=12ms
20:41:31.905 INFO  Sensor C# Properties [csharp]
20:41:31.906 INFO  Sensor C# Properties [csharp] (done) | time=1ms
20:41:31.906 INFO  Sensor JavaXmlSensor [java]
20:41:31.907 INFO  Sensor JavaXmlSensor [java] (done) | time=1ms
20:41:31.907 INFO  Sensor HTML [web]
20:41:31.909 INFO  Sensor HTML [web] (done) | time=2ms
20:41:31.909 INFO  Sensor VB.NET Project Type Information [vbnet]
20:41:31.910 INFO  Sensor VB.NET Project Type Information [vbnet] (done) | time=1ms
20:41:31.910 INFO  Sensor VB.NET Analysis Log [vbnet]
20:41:31.923 INFO  Sensor VB.NET Analysis Log [vbnet] (done) | time=13ms
20:41:31.923 INFO  Sensor VB.NET Properties [vbnet]
20:41:31.923 INFO  Sensor VB.NET Properties [vbnet] (done) | time=0ms
20:41:31.926 INFO  ------------- Run sensors on project
20:41:31.949 INFO  Sensor Zero Coverage Sensor
20:41:31.960 INFO  Sensor Zero Coverage Sensor (done) | time=11ms
20:41:31.962 INFO  SCM Publisher No SCM system was detected. You can use the 'sonar.scm.provider' property to specify it.
20:41:31.965 INFO  CPD Executor Calculating CPD for 1 file
20:41:31.984 INFO  CPD Executor CPD calculation finished (done) | time=19ms
20:41:32.134 INFO  Analysis report generated in 146ms, dir size=103.2 kB
20:41:32.149 INFO  Analysis report compressed in 15ms, zip size=14.4 kB
20:41:32.278 INFO  Analysis report uploaded in 126ms
20:41:32.281 INFO  ANALYSIS SUCCESSFUL, you can browse http://130.193.37.99:9000/dashboard?id=Netology
20:41:32.281 INFO  Note that you will be able to access the updated dashboard once the server has processed the analysis report
20:41:32.281 INFO  More about the report processing at http://130.193.37.99:9000/api/ce/task?id=AZAD4nkirWgtUsydeimQ
20:41:32.289 INFO  Analysis total time: 10.294 s
20:41:32.290 INFO  EXECUTION SUCCESS
20:41:32.291 INFO  Total time: 14.462s
```
</details>
