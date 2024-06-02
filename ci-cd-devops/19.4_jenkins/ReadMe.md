## 19.4 Jenkins - Вячеслав Закариев

### Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.
2. Установить Jenkins при помощи playbook.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

### Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
8. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
9. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.
10. Сопроводите процесс настройки скриншотами для каждого пункта задания!!

---

### Решение №1

1. Инициализировал проект для **terraform**

![init](https://github.com/SlavaZakariev/netology/blob/5ba01bb8650366acde0e385111cfd4a465862730/ci-cd-devops/19.4_jenkins/resources/ci-cd4_1.1.jpg)
 
2. Создали с помощью [terraform](https://github.com/SlavaZakariev/netology/tree/main/ci-cd-devops/19.4_jenkins/terraform) две ВМ **jenkins-master** и **jenkins-agent**. \
   **Примечание:** Сменил античный **Centos 7** на **Ubuntu 2204**, иначе новая версия **jenkins** не устанавливает свои плагины по умолчанию из-за несовместимости, также применял **Centos 8**, там конечно большое количество плагинов поставилось, но на некторых отвечающие на pipeline вылетают с ошибкой. Прошу исправить **playbook** в домашнем задании или же привязать жёстко совместимую версию **jenkins**, пришлось потратить очень много часов на анализ ошибок и дальшейную работу по переписке **playbook**, у не посвященных как я это отнимает много времени и начинаешь отставать от курса.

![apply](https://github.com/SlavaZakariev/netology/blob/448524d7d1f12a7baab1d9075f89ddcef6b51356/ci-cd-devops/19.4_jenkins/resources/ci-cd4_1.2.jpg)
![yc](https://github.com/SlavaZakariev/netology/blob/448524d7d1f12a7baab1d9075f89ddcef6b51356/ci-cd-devops/19.4_jenkins/resources/ci-cd4_1.3.jpg)

3. Проверил связь с виртуальными машинами.

![ping](https://github.com/SlavaZakariev/netology/blob/448524d7d1f12a7baab1d9075f89ddcef6b51356/ci-cd-devops/19.4_jenkins/resources/ci-cd4_1.4.jpg)

4. Установил [playbook](https://github.com/SlavaZakariev/netology/tree/main/ci-cd-devops/19.4_jenkins/ansible) \
   **Примечание:** Удалено задание **Reinstall Selinux** из playbook, так как для **Centos 8** она не нужна (выдаёт ошибку).

```yaml
sysadmin@ubuntu1:~/cicd04/ansible$ ansible-playbook site.yml -i inventory/hosts.yml

PLAY [Preapre all hosts] ********************************************************************************************
TASK [Gathering Facts] **********************************************************************************************
ok: [jenkins-agent]
ok: [jenkins-master]

TASK [Create group] *************************************************************************************************
ok: [jenkins-master]
ok: [jenkins-agent]

TASK [Create user] **************************************************************************************************
ok: [jenkins-master]
ok: [jenkins-agent]

TASK [Install JDK] **************************************************************************************************
ok: [jenkins-master]
ok: [jenkins-agent]

PLAY [Get Jenkins master installed] *********************************************************************************
TASK [Gathering Facts] **********************************************************************************************
ok: [jenkins-master]

TASK [Get repo Jenkins] *********************************************************************************************
ok: [jenkins-master]

TASK [Add Jenkins key] **********************************************************************************************
ok: [jenkins-master]

TASK [Update apt cache] *********************************************************************************************
changed: [jenkins-master]

TASK [Install Jenkins and requirements] *****************************************************************************
ok: [jenkins-master]

TASK [Ensure jenkins agents are present in known_hosts file] ********************************************************
# 178.154.207.17:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.7
# 178.154.207.17:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.7
# 178.154.207.17:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.7
# 178.154.207.17:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.7
# 178.154.207.17:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.7
ok: [jenkins-master] => (item=jenkins-agent)

TASK [Start Jenkins] ************************************************************************************************
skipping: [jenkins-master]

PLAY [Prepare jenkins agent] ****************************************************************************************
TASK [Gathering Facts] **********************************************************************************************
ok: [jenkins-agent]

TASK [Add master publickey into authorized_key] *********************************************************************
ok: [jenkins-agent]

TASK [Create agent_dir] *********************************************************************************************
ok: [jenkins-agent]

TASK [Add Docker GPG key] *******************************************************************************************
ok: [jenkins-agent]

TASK [Add Docker repository] ****************************************************************************************
ok: [jenkins-agent]

TASK [Update apt cache] *********************************************************************************************
changed: [jenkins-agent]

TASK [Install some packeges] ****************************************************************************************
changed: [jenkins-agent]

TASK [Install Docker] ***********************************************************************************************
ok: [jenkins-agent]

TASK [Update pip] ***************************************************************************************************
changed: [jenkins-agent]

TASK [Install Ansible] **********************************************************************************************
changed: [jenkins-agent]

TASK [Add local to PATH] ********************************************************************************************
changed: [jenkins-agent]

TASK [Create docker group] ******************************************************************************************
ok: [jenkins-agent]

TASK [Add jenkinsuser to dockergroup] *******************************************************************************
changed: [jenkins-agent]

TASK [Restart docker] ***********************************************************************************************
changed: [jenkins-agent]

TASK [Install agent.jar] ********************************************************************************************
changed: [jenkins-agent]

PLAY RECAP **********************************************************************************************************
jenkins-agent              : ok=19   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
jenkins-master             : ok=10   changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```
5. Разблокировка пользователя и аутентификация в jenkins

![jen1](https://github.com/SlavaZakariev/netology/blob/5ba01bb8650366acde0e385111cfd4a465862730/ci-cd-devops/19.4_jenkins/resources/ci-cd4_1.5.jpg)
