## 18.1 Введение в Ansible - Вячеслав Закариев

### Подготовка к выполнению

1. Установите Ansible версии 2.10 или выше.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

### Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.
2. Найдите файл (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте значения `some_fact` для каждого из `managed host`.
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения:
   - для `deb` — `deb default fact`
   - для `el` — `el default fact`.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
13. Предоставьте скриншоты результатов запуска команд.

---

Решение 1

1. Запускаем Playbook на локальный сервер

![ans01](https://github.com/SlavaZakariev/netology/blob/ea120408ccbcfc1773e0096283a64f5207e97c46/ansible/18.1_introduction/resources/ans1_1.1.jpg)

2. Повторяем Playbook на локальный сервер, предварительно сменив сообщение на "all default fact"

![ans02](https://github.com/SlavaZakariev/netology/blob/ea120408ccbcfc1773e0096283a64f5207e97c46/ansible/18.1_introduction/resources/ans1_1.2.jpg)

3. Разворачиваем контейнеры ubuntu и centos7 и запускаем Playbook

![ans03](https://github.com/SlavaZakariev/netology/blob/ea120408ccbcfc1773e0096283a64f5207e97c46/ansible/18.1_introduction/resources/ans1_1.3.jpg)

4. Повторяем Playbook для контейнеров, предварительно сменив сообщения с "deb" на "deb default fact" и "el" на "el default fact"

![ans04](https://github.com/SlavaZakariev/netology/blob/ea120408ccbcfc1773e0096283a64f5207e97c46/ansible/18.1_introduction/resources/ans1_1.4.jpg)

5. Шифрую файлы с сообщениями

![ans05](https://github.com/SlavaZakariev/netology/blob/ea120408ccbcfc1773e0096283a64f5207e97c46/ansible/18.1_introduction/resources/ans1_1.5.jpg)

6. Запуск шифрованного Playbook

![ans06](https://github.com/SlavaZakariev/netology/blob/2b6dc80fa672c2d1ebd2b98cf2df8a8170fc8b7f/ansible/18.1_introduction/resources/ans1_1.6.jpg)

7. Вывод список плагинов

![ans07](https://github.com/SlavaZakariev/netology/blob/ea120408ccbcfc1773e0096283a64f5207e97c46/ansible/18.1_introduction/resources/ans1_1.7.jpg)

8. Внесение локального сервера в файл инвентори

![ans08](https://github.com/SlavaZakariev/netology/blob/ea120408ccbcfc1773e0096283a64f5207e97c46/ansible/18.1_introduction/resources/ans1_1.8.jpg)

9. Запуск Playbook после внесения изменений в файл инвентори

![ans09](https://github.com/SlavaZakariev/netology/blob/d42a14f860c657c60b47fa7aaf896fb726c389b7/ansible/18.1_introduction/resources/ans1_1.9.jpg)

Ссылка на [playbook](https://github.com/SlavaZakariev/netology/tree/main/ansible/18.1_introduction/playbook)

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---
