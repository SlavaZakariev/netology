## 18.2 Работа с Playbook - Вячеслав Закариев

### Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-02-playbook/playbook) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

### Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install). не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook). Так же приложите скриншоты выполнения заданий №5-8
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на коммит, в ответ предоставьте ссылку.

---

### Решение 1

1. Развёрнуты 2 ВМ на **Hyper-V**

![VMs](https://github.com/SlavaZakariev/netology/blob/2e4a33a6a6bc0c78b341a89a471c493c49f46bba/ansible/18.2_playbook/resources/ans2_1.5.jpg)

2. Добавляем **SSH** ключи и проверяем связь через **Ansible**

![ping](https://github.com/SlavaZakariev/netology/blob/2e4a33a6a6bc0c78b341a89a471c493c49f46bba/ansible/18.2_playbook/resources/ans2_1.1.jpg)

3. Добавлены ВМ в файл invertory

```yaml
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: ssh
      ansible_ssh_user: root
      ansible_host: 172.23.189.19
      ansible_private_key_file: ~/.ssh/id_ed25519

vector:
  hosts:
    vector-01:
      ansible_connection: ssh
      ansible_ssh_user: root
      ansible_host: 172.23.191.3
      ansible_private_key_file: ~/.ssh/id_ed25519
```

4. Написан **Playbook** для **Vector**, добавлен вторым плеем к **Clickhouse**

**Примечание:** Постоянно выходила ошибка при использовании модуля распаковки, добавил **handler** с командой распаковки. \
Возможно какая-то несовместимость версии ansible **2.10.8** с модулем распаковки архивов **gz.tar**

```yaml
- name: Install Vector
  hosts: vector-01
  pre_tasks:
    - name: Get Vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/0.33.0/vector-{{ vector_version }}-{{ vector_architecture }}-unknown-linux-gnu.tar.gz"
        dest: "./vector-{{ vector_version }}-{{ vector_architecture }}-unknown-linux-gnu.tar.gz"
    - name: Create Vector directory
      become: true
      ansible.builtin.file:
        path: /etc/vector
        state: directory
  handlers:
    - name: Unarchive Vector package 
      ansible.builtin.command: "tar -xf ./vector-{{ vector_version }}-{{ vector_architecture }}-unknown-linux-gnu.tar.gz -C /ect/vector"
  tasks:
    - name: Template file
      become: true
      ansible.builtin.template:
        src: vector.toml.j2
        dest: /etc/vector/vector.toml
        mode: '0644'
    - name: Run Vector
      become: true
      ansible.builtin.shell: /etc/vector/vector-x86_64-unknown-linux-gnu/bin/vector --config /etc/vector/vector.toml &
  tags: vector
```

5. Запускаем **Playbook**

![playbook1](https://github.com/SlavaZakariev/netology/blob/224a40906b106ebe8a4c8b9645fa0c8ea23d074a/ansible/18.2_playbook/resources/ans2_1.2.jpg)

6. Запускаем **Playbook** c флагом **--check**

![playbook2](https://github.com/SlavaZakariev/netology/blob/224a40906b106ebe8a4c8b9645fa0c8ea23d074a/ansible/18.2_playbook/resources/ans2_1.3.jpg)

7. Дважды запускаем **Playbook** с флагом **--diff**

![playbook3](https://github.com/SlavaZakariev/netology/blob/224a40906b106ebe8a4c8b9645fa0c8ea23d074a/ansible/18.2_playbook/resources/ans2_1.4.jpg)

8. Ссылка на [Playbook](https://github.com/SlavaZakariev/netology/tree/main/ansible/18.2_playbook/playbook)
