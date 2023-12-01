## 8.2 Ansible. Часть 2 - Вячеслав Закариев

### Задание 1

Выполните действия, приложите файлы с плейбуками и вывод выполнения.
Напишите три плейбука. При написании рекомендуем использовать текстовый редактор с подсветкой синтаксиса YAML.

Плейбуки должны:

1. Скачать какой-либо архив, создать папку для распаковки и распаковать скаченный архив. Например, можете использовать [официальный сайт](https://kafka.apache.org/downloads) и зеркало Apache Kafka. При этом можно скачать как исходный код, так и бинарные файлы, запакованные в архив — в нашем задании не принципиально.
2. Установить пакет tuned из стандартного репозитория вашей ОС. Запустить его, как демон — конфигурационный файл systemd появится автоматически при установке. Добавить tuned в автозагрузку.
3. Изменить приветствие системы (motd) при входе на любое другое. Пожалуйста, в этом задании используйте переменную для задания приветствия. Переменную можно задавать любым удобным способом.

---

### Решение 1

1. Написан playbook unpack.yaml

```
---
- name: Download and Unpacking
  hosts: servers
  become: yes
  become_method: sudo
  
  tasks:
    - name: Download archive
      get_url:
        url: https://downloads.apache.org/kafka/3.5.0/kafka-3.5.0-src.tgz
        dest: /tmp/kafka-3.5.0-src.tgz

    - name: Create directory
      file:
        path: /tmp/extracted
        state: directory

    - name: Unpacking
      unarchive:
        remote_src: yes
        src: /tmp/kafka-3.5.0-src.tgz
        dest: /tmp/extracted
```

Запущено выполнение командой ***ansible-playbook .ansible/playbooks/unpack.yaml -K***

![upack.yaml](https://github.com/SlavaZakariev/netology/blob/5d54807054a02a507a7510797c4b9fd0faf9791a/ci-cd/7.2_ansible_part2/resources/ansible2_1.2.jpg)

2. Установка tuned

```
---
- name: Install Tuned
  hosts: servers
  become: yes
  become_method: sudo
  
  tasks:
    - name: install tuned
      apt:
        name: tuned
        state: present

    - name: autorun tuned
      service:
        name: tuned
        state: started
        enabled: yes

```

![tuned](https://github.com/SlavaZakariev/netology/blob/e592719b036e3c99e081734d16137e7900725712/ci-cd/7.2_ansible_part2/resources/ansible2_2.1.jpg)

---

3. Playbook motd

```
---
- name: Edit motd
  hosts: servers
  become: yes
  become_method: sudo

  tasks:
    - name: variables
      include_vars:
        file: motd_vars.yaml

    - name: change motd
      template:
        src: motd.txt
        dest: /etc/motd

```

motd_vars.yaml

```
---
motd:
  name: Viacheslav
  course: DevOps
  
```

motd.txt

```
---
Variables:

var1: {{ motd.name }}
var2: {{ motd.course }}

```

![motd](https://github.com/SlavaZakariev/netology/blob/edb48e8665cd4a2fbebe88ce8a0a2fc21936a1dc/ci-cd/7.2_ansible_part2/resources/ansible2_3.1.jpg)

Приветствие на управляемых серверах Ubuntu2 и Ubuntu3

![vars](https://github.com/SlavaZakariev/netology/blob/edb48e8665cd4a2fbebe88ce8a0a2fc21936a1dc/ci-cd/7.2_ansible_part2/resources/ansible2_3.3.jpg)

---

### Задание 2

Выполните действия, приложите файлы с модифицированным плейбуком и вывод выполнения.
Модифицируйте плейбук из пункта 3, задания 1. В качестве приветствия он должен установить IP-адрес и hostname управляемого хоста, пожелание хорошего дня системному администратору.

---

### Решение 2

Обновлённый motd.txt

```
---
- name: Edit motd
  hosts: servers
  become: yes
  become_method: sudo

  tasks:
    - name: change motd
      template:
        src: motd.txt
        dest: /etc/motd

```
Результат обновления

![update](https://github.com/SlavaZakariev/netology/blob/4466ac74430003511f2358790c590ff7d6d89d5f/ci-cd/7.2_ansible_part2/resources/ansible2_4.1.jpg)

Вывод приветствия

![update](https://github.com/SlavaZakariev/netology/blob/4466ac74430003511f2358790c590ff7d6d89d5f/ci-cd/7.2_ansible_part2/resources/ansible2_4.2.jpg)

---

### Задание 3

Выполните действия, приложите архив с ролью и вывод выполнения.
Ознакомьтесь со статьёй «Ansible - это вам не bash», сделайте соответствующие выводы и не используйте модули shell или command при выполнении задания.

Создайте плейбук, который будет включать в себя одну, созданную вами роль. Роль должна:

1. Установить веб-сервер Apache на управляемые хосты.
2. Сконфигурировать файл index.html c выводом характеристик каждого компьютера как веб-страницу по умолчанию для Apache. Необходимо включить CPU, RAM, величину первого HDD, IP-адрес. Используйте Ansible facts и jinja2-template
3. Открыть порт 80, если необходимо, запустить сервер и добавить его в автозагрузку.
4. Сделать проверку доступности веб-сайта (ответ 200, модуль uri).

В качестве решения:

* предоставьте плейбук, использующий роль;
* разместите архив созданной роли у себя на Google диске и приложите ссылку на роль в своём решении;
* предоставьте скриншоты выполнения плейбука;
* предоставьте скриншот браузера, отображающего сконфигурированный index.html в качестве сайта.

---

### Решение 3
