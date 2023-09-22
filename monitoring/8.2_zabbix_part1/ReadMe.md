## 8.2 Система мониторинга Zabbix. Часть 1 - Вячеслав Закариев

### Задание 1 

Установите Zabbix Server с веб-интерфейсом.

#### Процесс выполнения
1. Выполняя ДЗ сверяйтесь с процессом отражённым в записи лекции.
2. Установите PostgreSQL. Для установки достаточна та версия что есть в системном репозитороии Debian 11
3. Пользуясь конфигуратором комманд с официального сайта, составьте набор команд для установки последней версии Zabbix с поддержкой PostgreSQL и Apache
4. Выполните все необходимые команды для установки Zabbix Server и Zabbix Web Server

#### Требования к результаты 
1. Прикрепите в файл README.md скриншот авторизации в админке
2. Приложите в файл README.md текст использованных команд в GitHub

---

### Решение 1

Для установки поднят сервер Ubuntu 22.04.2 LTS

![ver](https://github.com/SlavaZakariev/netology/blob/f60fbdff14e9582da19c39ff1d46e6aa476f955c/monitoring/8.2_zabbix_part1/resources/zabbix1_1.1.jpg)

```
# 1. Установка СУБД PosgreSQL
apt update
apt install postgresql 

# 2. Установка репозитория Zabbix
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
apt update

# 3. Установка Zabbix сервер, веб-интерфейс
apt install zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-apache-conf zabbix-sql-scripts

# 4. Установка роли zabbix и БД для сервиса zabbix в СУБД PosgreSQL
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix

# 5. Импорт начальных схем и данных
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix

# 6. Добавлен пароль в файл конфигурации /etc/zabbix/zabbix_server.conf
DBPassword=password

# 7. Перезапуск сервиса, настройка zabbix сервера и веб-сервера apache при загрузке ОС
systemctl restart zabbix-server apache2
systemctl enable zabbix-server apache2

```

Проверка службы zabbix

![status](https://github.com/SlavaZakariev/netology/blob/f60fbdff14e9582da19c39ff1d46e6aa476f955c/monitoring/8.2_zabbix_part1/resources/zabbix1_1.2.jpg)

Первичная настройка веб-интерфейса 

![status](https://github.com/SlavaZakariev/netology/blob/22f56dece440a9a20a2776bd7c3c67ccacc2e705/monitoring/8.2_zabbix_part1/resources/zabbix1_1.3.jpg)

Успешное завершение всех шагов первичной настройки веб-интерфейса 

![status](https://github.com/SlavaZakariev/netology/blob/22f56dece440a9a20a2776bd7c3c67ccacc2e705/monitoring/8.2_zabbix_part1/resources/zabbix1_1.4.jpg)

Авторизация в админке сервера zabbix

![admin](https://github.com/SlavaZakariev/netology/blob/22f56dece440a9a20a2776bd7c3c67ccacc2e705/monitoring/8.2_zabbix_part1/resources/zabbix1_1.5.jpg)

---

### Задание 2 

Установите Zabbix Agent на два хоста.

#### Процесс выполнения
1. Выполняя ДЗ сверяйтесь с процессом отражённым в записи лекции.
2. Установите Zabbix Agent на 2 виртмашины, одной из них может быть ваш Zabbix Server
3. Добавьте Zabbix Server в список разрешенных серверов ваших Zabbix Agentов
4. Добавьте Zabbix Agentов в раздел Configuration > Hosts вашего Zabbix Servera
5. Проверьте что в разделе Latest Data начали появляться данные с добавленных агентов

#### Требования к результаты 
1. Приложите в файл README.md скриншот раздела Configuration > Hosts, где видно, что агенты подключены к серверу
2. Приложите в файл README.md скриншот лога zabbix agent, где видно, что он работает с сервером
3. Приложите в файл README.md скриншот раздела Monitoring > Latest data, где видны поступающие от агентов данные.
4. Приложите в файл README.md текст использованных команд в GitHub

---

### Решение 2

1. Добавление двух хостов и проверка работы сервиса zabbix агентов на хостах

![service](https://github.com/SlavaZakariev/netology/blob/ce83620940d6bf4e40f27a5428185499aad04f37/monitoring/8.2_zabbix_part1/resources/zabbix1_1.8.jpg)

2. Добавлены хосты в zabbix

![hosts](https://github.com/SlavaZakariev/netology/blob/470de14a519ff96d7d3963480a8f7154c281bd95/monitoring/8.2_zabbix_part1/resources/zabbix1_1.6.jpg)

3. Данные мониторинга "Latest data"

![latest](https://github.com/SlavaZakariev/netology/blob/470de14a519ff96d7d3963480a8f7154c281bd95/monitoring/8.2_zabbix_part1/resources/zabbix1_1.7.jpg)

4. Команды использованные для установки zabbix агентов на хостах Ubuntu2 и Ubuntu3

``` 
# 1. Установка репозитория Zabbix
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
apt update

# 2. Установка Zabbix агента
apt install zabbix-agent

# 3. Перезапуск сервиса, настройка zabbix агента при загрузке ОС
systemctl restart zabbix-agent
systemctl enable zabbix-agent

```
