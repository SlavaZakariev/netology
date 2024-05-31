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
   
2. Создали с помощью [terraform](https://github.com/SlavaZakariev/netology/tree/main/ci-cd-devops/19.4_jenkins/terraform) две ВМ **jenkins-master** и **jenkins-agent**. \
   Примечание: Сменил античный Centos 7 на Centos 8, иначе новая версия **jenkins** не устанавливает свои плагины по умолчанию из-за несовместимости. Прошу исправить playbook в домашнем задании или же привязать жёстко совместимую версию **jenkins**
  
4. Проверил связь с виртуальными машинами.

5. Установил [playbook](https://github.com/SlavaZakariev/netology/tree/main/ci-cd-devops/19.4_jenkins/ansible).
   **Примечание:** Удалено задание **Reinstall Selinux** из playbook, так как для **Centos 8** она не нужна (выдаёт ошибку).

```yaml
sysadmin@ubuntu1:~/cicd04/ansible$ ansible-playbook site.yml -i inventory/hosts.yml

PLAY [Preapre all hosts] ***********************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [jenkins-agent]
ok: [jenkins-master]

TASK [Create group] ****************************************************************************************************
changed: [jenkins-master]
changed: [jenkins-agent]

TASK [Create user] *****************************************************************************************************
changed: [jenkins-master]
changed: [jenkins-agent]

TASK [Install JDK] *****************************************************************************************************
changed: [jenkins-master]
changed: [jenkins-agent]

PLAY [Get Jenkins master installed] ************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [jenkins-master]

TASK [Get repo Jenkins] ************************************************************************************************
changed: [jenkins-master]

TASK [Add Jenkins key] *************************************************************************************************
changed: [jenkins-master]

TASK [Install epel-release] ********************************************************************************************
changed: [jenkins-master]

TASK [Install Jenkins and requirements] ********************************************************************************
changed: [jenkins-master]

TASK [Ensure jenkins agents are present in known_hosts file] ***********************************************************
# 158.160.62.97:22 SSH-2.0-OpenSSH_8.0
# 158.160.62.97:22 SSH-2.0-OpenSSH_8.0
# 158.160.62.97:22 SSH-2.0-OpenSSH_8.0
# 158.160.62.97:22 SSH-2.0-OpenSSH_8.0
# 158.160.62.97:22 SSH-2.0-OpenSSH_8.0
changed: [jenkins-master] => (item=jenkins-agent)
[WARNING]: Module remote_tmp /home/jenkins/.ansible/tmp did not exist and was created with a mode of 0700, this may cause
issues when running as another user. To avoid this, create the remote_tmp dir with the correct permissions manually

TASK [Start Jenkins] ***************************************************************************************************
changed: [jenkins-master]

PLAY [Prepare jenkins agent] *******************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [jenkins-agent]

TASK [Add master publickey into authorized_key] ************************************************************************
changed: [jenkins-agent]

TASK [Create agent_dir] ************************************************************************************************
changed: [jenkins-agent]

TASK [Add docker repo] *************************************************************************************************
changed: [jenkins-agent]

TASK [Install some required] *******************************************************************************************
changed: [jenkins-agent]

TASK [Update pip] ******************************************************************************************************
changed: [jenkins-agent]

TASK [Install Ansible] *************************************************************************************************
changed: [jenkins-agent]

TASK [Add local to PATH] ***********************************************************************************************
changed: [jenkins-agent]

TASK [Create docker group] *********************************************************************************************
ok: [jenkins-agent]

TASK [Add jenkinsuser to dockergroup] **********************************************************************************
changed: [jenkins-agent]

TASK [Restart docker] **************************************************************************************************
changed: [jenkins-agent]

TASK [Install agent.jar] ***********************************************************************************************
changed: [jenkins-agent]

PLAY RECAP *************************************************************************************************************
jenkins-agent              : ok=16   changed=13   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
jenkins-master             : ok=11   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
5. Разблокировка пользователя и аутентификация в jenkins

