## 16.4 Практическое применение Docker - Вячеслав Закариев

### Примечание: Ознакомьтесь со схемой виртуального стенда [по ссылке](https://github.com/netology-code/shvirtd-example-python/blob/main/schema.pdf)

### Задача 1

1. Сделайте в своем github пространстве fork репозитория \
   `https://github.com/netology-code/shvirtd-example-python/blob/main/README.md`   
3. Создайте файл с именем `Dockerfile.python` для сборки данного проекта. Используйте базовый образ `python:3.9-slim` \
   Протестируйте корректность сборки. Не забудьте dockerignore.
5. (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker в venv. (Mysql БД можно запустить в docker run).
6. (Необязательная часть, *) По образцу предоставленного python кода внесите в него исправление для управления названием используемой таблицы через ENV переменную.

---

### Решение 1

1. Скачан репозиторий **shvirtd-example-python**
2. Написан **Dockerfile.python**

```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY main.py ./
CMD ["python", "main.py"]
```

3. Собираем контейнер.

![py1](https://github.com/SlavaZakariev/netology/blob/d634e7549d049a8083ee246f43b93b41c741d574/virtualization-containerization/16.4_docker/resources/dcf_1.1.jpg)

4. Проверяем наличие вновь созданного снимка

![py2](https://github.com/SlavaZakariev/netology/blob/d634e7549d049a8083ee246f43b93b41c741d574/virtualization-containerization/16.4_docker/resources/dcf_1.2.jpg)

---

### Задача 2 (*)

1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
2. Настройте аутентификацию вашего локального docker в yandex container registry.
3. Соберите и залейте в него образ с python приложением из задания №1.
4. Просканируйте образ на уязвимости.
5. В качестве ответа приложите отчет сканирования.

---

### Задача 3

1. Создайте файл ```compose.yaml```. Опишите в нем следующие сервисы: 

- ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 

- ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте .env file для назначения секретных ENV-переменных!

2. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы.Протестируйте приложение с помощью команд ```curl -L http://127.0.0.1:8080``` и ```curl -L http://127.0.0.1:8090```.

5. Подключитесь к БД mysql с помощью команды ```docker exec <имя_контейнера> mysql -uroot -p<пароль root-пользователя>``` . Введите последовательно команды (не забываем в конце символ ; ): ```show databases; use <имя вашей базы данных(по-умолчанию example)>; show tables; SELECT * from requests LIMIT 10;```.

6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.

---

### Решение 3

1. Написан манифест с учётом заданных условий.

```yaml
version: '3.8'
services:

  web:
    build:
      context: ./                   # путь до докерфайла
      dockerfile: Dockerfile.python # имя докерфайла
    container_name: web             # имя контейнера
    ports:                          # проброс портов
      - '5000:5000'
    restart: always                 # перезапуск контейнера
    networks:
      backend:                      # добавить в сеть backend
       ipv4_address: 172.20.0.5     # статический IPv4

  db:
    image: mysql:8.0   # версия снимка
    container_name: db # имя контейнера
    ports:             # проброс портов
      - '3306:3306'
    restart: always    # перезапуск контейнера
    env_file: .env     # файл с переменными
    volumes:           # том и проброс файла в директории
      - ./mysql/my.conf:/etc/mysql/my.cnf:ro
    environment:
      - TZ=Europe/Moscow # установка часового пояса МСК
      - MYSQL_ROOT_PASSWORD:${MYSQL_ROOT_PASSWORD}
      - DB_HOST:${DB_HOST}
      - DB_USER:${DB_USER}
      - DB_PASSWORD:${DB_PASSWORD}
      - DB_NAME:${DB_NAME}
      # Все параметры описываем в файле .env в папке проекта
    networks:
      backend:                    # добавить в сеть backend
        ipv4_address: 172.20.0.10 # статический IPv4

  reverse-proxy:
    image: haproxy
    container_name: reverse-proxy
    restart: always
    ports:
    - '127.0.0.1:8080:8080'
    volumes:
    - ./haproxy/reverse/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:rw
    networks:
      backend:                    # добавить в сеть backend
        ipv4_address: 172.20.0.11 # статический IPv4

  ingress-proxy:
    image: nginx:latest
    container_name: ingress-proxy
    restart: always
    volumes:
    - ./nginx/ingress/default.conf:/etc/nginx/conf.d/default.conf:rw
    - ./nginx/ingress/nginx.conf:/etc/nginx/nginx.conf:rw
    network_mode: host

networks:            # создание сети
  backend:           # название сети контейнеров
    driver: bridge   # тип драйвера сети
    ipam:            # описание параметров сети
      config:
        - subnet: 172.20.0.0/24 # подсеть
          gateway: 172.20.0.1   # шлюз
```

2. Результат выполнения манифеста

![web-db1](https://github.com/SlavaZakariev/netology/blob/a657a8c29036a3e4aab6ac81ab368b34a44124ce/virtualization-containerization/16.4_docker/resources/dcf_3.1.jpg)

3. Проверка стабильности работы контейнеров.

![web-dc2](https://github.com/SlavaZakariev/netology/blob/a657a8c29036a3e4aab6ac81ab368b34a44124ce/virtualization-containerization/16.4_docker/resources/dcf_3.2.jpg)

3. Проверка соединение с хостового сервера по проброшенным портам.

![curl](https://github.com/SlavaZakariev/netology/blob/a657a8c29036a3e4aab6ac81ab368b34a44124ce/virtualization-containerization/16.4_docker/resources/dcf_3.3.jpg)

4. Выполнено подключение к контейнеру **db**, далее к **mysql** через пользователя **root** \
   Переключились на созданную через **.env** базу данных **example**

![mysql](https://github.com/SlavaZakariev/netology/blob/a657a8c29036a3e4aab6ac81ab368b34a44124ce/virtualization-containerization/16.4_docker/resources/dcf_3.4.jpg)

5. Остановка проекта командой **docker compose down**

![down](https://github.com/SlavaZakariev/netology/blob/a657a8c29036a3e4aab6ac81ab368b34a44124ce/virtualization-containerization/16.4_docker/resources/dcf_3.5.jpg)
 

---

### Задача 4

1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).
2. Подключитесь к Вм по ssh и установите docker.
3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.
4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` \
   и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:5000```.
6. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```
7. В качестве ответа повторите sql-запрос и приложите скриншот с данного сервера, bash-скрипт и ссылку на fork-репозиторий.

---

### Решение 4

1. Создана виртуальная машина на Ubuntu 22.04

![yc](https://github.com/SlavaZakariev/netology/blob/5daad8a3296e3b32b7c3009a0571f7cad70e4b66/virtualization-containerization/16.4_docker/resources/dcf_4.1.jpg)

2. Выполнено соединение по **ssh** через терминал **windows** и установлен **docker**

![docker](https://github.com/SlavaZakariev/netology/blob/de67e6b08455596742d2e98951c139ce0299ce0a/virtualization-containerization/16.4_docker/resources/dcf_4.2.jpg)

3. Скрипт bash для автоматизации сборки

```bash
#!/bin/bash
echo "Cloning the project from GitHub"
  git clone https://github.com/SlavaZakariev/shvirtd-example-python
echo "Done"

echo "Entering the project directory"
  cd shvirtd-example-python
echo "Done"

echo "Creating docker containers: db, app, proxy and nginx"
  sudo docker compose up -d
echo "Done"

echo "List of containers"
  sudo docker ps
```

4. Запуск скрипта **yandex-vm.sh** на ВМ в **Yandex Cloud**

![bash](https://github.com/SlavaZakariev/netology/blob/5c21a77bd8713b504e016db644005a4192862e35/virtualization-containerization/16.4_docker/resources/dcf_4.3.jpg)

6. Ссылка на проект на [GitHub](https://github.com/SlavaZakariev/shvirtd-example-python/blob/main/README.md)

---

### Задача 5 (*)

1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."
2. Протестируйте ручной запуск
3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer.
4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"

---

## Задача 6

Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
Предоставьте скриншоты действий.

### Задача 6.1
Добейтесь аналогичного результата, используя docker cp.  
Предоставьте скриншоты действий.

### Задача 6.2 (**)
Предложите способ извлечь файл из контейнера, используя только команду docker build и любой Dockerfile.  
Предоставьте скриншоты действий.

---

### Решение 6

1. Скачиваем снимок **hashicorp/terraform:latest**

![terraform](https://github.com/SlavaZakariev/netology/blob/0237ca6721c8fc53e8155f16d54ec43486cf329d/virtualization-containerization/16.4_docker/resources/dcf_6.1.jpg)

2. Скачиваем приложение **dive** версия **0.11.0**

```
curl -OL https://github.com/wagoodman/dive/releases/download/v0.11.0/dive_0.11.0_linux_amd64.deb
```

![dive](https://github.com/SlavaZakariev/netology/blob/0237ca6721c8fc53e8155f16d54ec43486cf329d/virtualization-containerization/16.4_docker/resources/dcf_6.2.jpg)

3. Открываем скаченный снимок с помощью **dive**

```
dive hashicorp/terraform
```

![open-dive](https://github.com/SlavaZakariev/netology/blob/0237ca6721c8fc53e8155f16d54ec43486cf329d/virtualization-containerization/16.4_docker/resources/dcf_6.3.jpg)

4. Скачиваем необходимый файл, в нашем случае бинарный файл **terraform**

```
docker image save hashicorp/terraform | tar --extract --wildcards --to-stdout '*/layer.tar' | tar --extract --ignore-zeros --verbose bin/terraform
```

![download](https://github.com/SlavaZakariev/netology/blob/0237ca6721c8fc53e8155f16d54ec43486cf329d/virtualization-containerization/16.4_docker/resources/dcf_6.4.jpg)

---

### Решение 6.1

1. Создаём контейнер из снимка без запуска самого контейнера

```
docker create --name terraform01 hashicorp/terraform
```

![create](https://github.com/SlavaZakariev/netology/blob/f184d8bf52298f76a4382342dc0489e9c22e2f74/virtualization-containerization/16.4_docker/resources/dcf_6.5.jpg)

2. Копируем необходимый файл из контейнера по пути куда хотим сохранить

```
docker cp terraform01:/bin/terraform ./
```

![cp](https://github.com/SlavaZakariev/netology/blob/f184d8bf52298f76a4382342dc0489e9c22e2f74/virtualization-containerization/16.4_docker/resources/dcf_6.6.jpg)

---

### Задача 7 (***)
Запустите ваше python-приложение с помощью runC, не используя docker или containerd.  
Предоставьте скриншоты действий.
