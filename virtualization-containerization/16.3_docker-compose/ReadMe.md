## 16.3 Оркестрация Docker контейнеров на примере Docker Compose - Вячеслав Закариев

### Задача 1

Сценарий выполнения задачи:
- Установите docker и docker compose plugin на свою linux рабочую станцию или ВМ.
- Зарегистрируйтесь и создайте публичный репозиторий  с именем "custom-nginx" на https://hub.docker.com;
- Скачайте образ nginx:1.21.1;
- Создайте Dockerfile и реализуйте в нем замену дефолтной индекс-страницы(/usr/share/nginx/html/index.html), на файл index.html с содержимым:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```
- Соберите и отправьте созданный образ в свой dockerhub-репозитории c tag 1.0.0 . 
- Предоставьте ответ в виде ссылки на https://hub.docker.com/<username_repo>/custom-nginx/general .

---

### Решение 1

1. Устанавливаем **docker** и **docker-compose**, далее скачиваем снимок **nginx:1.21.1** согласно условию

![docker](https://github.com/SlavaZakariev/netology/blob/6dbad63a480c347cf265b707e983d2f8209e7683/virtualization-containerization/16.3_docker-compose/resources/dc_1.1.jpg)

2. Создаём репозиторий [custom-nginx](https://hub.docker.com/repository/docker/slavazakariev/custom-nginx/general) в hub.docker.com
3. Подготавливаем **Dockerfile**, далее собираем контейнер с указанием тэга.

```dockerfile
FROM nginx:1.21.1
LABEL author=Zakariev
COPY ./index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

![dockerfile](https://github.com/SlavaZakariev/netology/blob/6dbad63a480c347cf265b707e983d2f8209e7683/virtualization-containerization/16.3_docker-compose/resources/dc_1.3.jpg)

4. Авторизируемся на hub.docker.com, далее загружаем контейнер в созданный [репозиторий](https://hub.docker.com/layers/slavazakariev/custom-nginx/nginx/images/sha256-7910c94e09b7433c43c428664a9ad5389cf44a6755c464da6f03440c1a12eab5?context=repo)

![hub](https://github.com/SlavaZakariev/netology/blob/d161515e8a5bf1175635e87a9a29931a3c634529/virtualization-containerization/16.3_docker-compose/resources/dc_1.4.jpg)

```
docker pull slavazakariev/custom-nginx:1.0.0
```

---

### Задача 2
1. Запустите ваш образ custom-nginx:1.0.0 командой docker run в соответствии с требованиями:
- имя контейнера "ФИО-custom-nginx-t2"
- контейнер работает в фоне
- контейнер опубликован на порту хост системы 127.0.0.1:8080
2. Переименуйте контейнер в "custom-nginx-t2"
3. Выполните команды: \
`date +"%d-%m-%Y %T.%N %Z" && sleep 0.150 && docker ps && ss -tlpn | grep 127.0.0.1:8080` \
`docker logs custom-nginx-t2 -n1 && docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html`
4. Убедитесь с помощью curl или веб браузера, что индекс-страница доступна.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

---

### Решение 2

1. Запускаем контейнер из снимка **custom-nginx** с именем согласно условию.

![cont1](https://github.com/SlavaZakariev/netology/blob/2b26342c8edbd8355f7911084aca9ffb0ce995f2/virtualization-containerization/16.3_docker-compose/resources/dc_2.1.jpg)

2. Переименовываем контейнер, выполняем команды заданные в условии.

![cont2](https://github.com/SlavaZakariev/netology/blob/2b26342c8edbd8355f7911084aca9ffb0ce995f2/virtualization-containerization/16.3_docker-compose/resources/dc_2.2.jpg)

3. Отображаем страницу **index.html** контейнера

![cont3](https://github.com/SlavaZakariev/netology/blob/2b26342c8edbd8355f7911084aca9ffb0ce995f2/virtualization-containerization/16.3_docker-compose/resources/dc_2.3.jpg)

---

### Задача 3

1. Воспользуйтесь docker help или google, чтобы узнать как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2".
2. Подключитесь к контейнеру и нажмите комбинацию Ctrl-C.
3. Выполните ```docker ps -a``` и объясните своими словами почему контейнер остановился.
4. Перезапустите контейнер
5. Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.
6. Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
7. Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".
8. Запомните(!) и выполните команду ```nginx -s reload```, а затем внутри контейнера ```curl http://127.0.0.1:80 && curl http://127.0.0.1:81```.
9. Выйдите из контейнера, набрав в консоли  ```exit``` или Ctrl-D.
10. Проверьте вывод команд: ```ss -tlpn | grep 127.0.0.1:8080``` , ```docker port custom-nginx-t2```, ```curl http://127.0.0.1:8080```. Кратко объясните суть возникшей проблемы.
11. * Это дополнительное, необязательное задание. Попробуйте самостоятельно исправить конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. [пример источника](https://www.baeldung.com/linux/assign-port-docker-container)
12. Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

---

### Решение 3

1. Подключаемся к контейнеру с помощью **docker attach**, далее выходи с помощью команды **Ctrl-C**.
2. Нажатие Ctrl-C способ завершения сеанса. Без ключей -d или -it, команда останавливает контейнер, а не отключается от него.

![attach](https://github.com/SlavaZakariev/netology/blob/2ad6bebc8ae91cb1a21d1d4e7c3b26c6d638eab3/virtualization-containerization/16.3_docker-compose/resources/dc_3.1.jpg)

3. Подключаемся к контейнеру интерактивно с помощью команды **docker exec** с ключом **-it**, далее устанавливаем редактор **nano**.

![nano](https://github.com/SlavaZakariev/netology/blob/2ad6bebc8ae91cb1a21d1d4e7c3b26c6d638eab3/virtualization-containerization/16.3_docker-compose/resources/dc_3.2.jpg)

4. Редактируем порт в файле **default.conf**, перезапускаем сервис **nginx**, после проверяем доступность страницы по старому порту.
5. Выходим из контейнера.
6. Проверяем порт 8080, который проброшен на 80 порт в контейнере, но так как мы заменили его 81-м портом, выходит ошибка.
7. Удаляем контейнер **docker rm** с ключом **-f**, **--force** то есть принудительно.

![exec](https://github.com/SlavaZakariev/netology/blob/2ad6bebc8ae91cb1a21d1d4e7c3b26c6d638eab3/virtualization-containerization/16.3_docker-compose/resources/dc_3.3.jpg)

---

### Задача 4

- Запустите первый контейнер из образа ***centos*** c любым тегом в фоновом режиме, подключив папку текущий рабочий каталог ```$(pwd)``` на хостовой машине в ```/data``` контейнера.
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив текущий рабочий каталог ```$(pwd)``` в ```/data``` контейнера. 
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```.
- Добавьте ещё один файл в каталог ```/data``` на хостовой машине.
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

---

### Решение 4

1. Разворачиваем два контейнера **centos** и **debian** с томами текущей папки проекта в папку **/data** для контейнеров.

![cent](https://github.com/SlavaZakariev/netology/blob/fa0d68cec5fc540c5de55cd14a13f42f7375ccaa/virtualization-containerization/16.3_docker-compose/resources/dc_4.1.jpg)

2. Создаём файл **file1** внутри контейнера **centos** в папке **/data**. Выходим из контейнера.
3. Создаём файл **file2** внутри папки проекта на хосте, примонтированная для обоих контейнеров.
4. Заходим в контейнер **debian** и проверяем наличие созданных ранее файлов в общем томе.

![deb](https://github.com/SlavaZakariev/netology/blob/fa0d68cec5fc540c5de55cd14a13f42f7375ccaa/virtualization-containerization/16.3_docker-compose/resources/dc_4.2.jpg)

---

### Задача 5

1. Создайте отдельную директорию(например /tmp/netology/docker/task5) и 2 файла внутри него.
"compose.yaml" с содержимым:
```yaml
version: "3"
services:
  portainer:
    image: portainer/portainer-ce:latest
    network_mode: host
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
"docker-compose.yaml" с содержимым:
```yaml
version: "3"
services:
  registry:
    image: registry:2
    network_mode: host
    ports:
    - "5000:5000"
```

И выполните команду "docker compose up -d". Какой из файлов был запущен и почему? (подсказка: https://docs.docker.com/compose/compose-file/03-compose-file/)

2. Отредактируйте файл compose.yaml так, чтобы были запущенны оба файла. (подсказка: https://docs.docker.com/compose/compose-file/14-include/)

3. Выполните в консоли вашей хостовой ОС необходимые команды чтобы залить образ custom-nginx как custom-nginx:latest в запущенное вами, локальное registry. Дополнительная документация: https://distribution.github.io/distribution/about/deploying/
4. Откройте страницу "https://127.0.0.1:9000" и произведите начальную настройку portainer.(логин и пароль адмнистратора)
5. Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше local  окружение. Перейдите на вкладку "stacks" и в "web editor" задеплойте следующий компоуз:

```yaml
version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
```
6. Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", выберите контейнер с nginx и нажмите на кнопку "inspect". В представлении <> Tree разверните поле "Config" и сделайте скриншот от поля "AppArmorProfile" до "Driver".

7. Удалите любой из манифестов компоуза(например compose.yaml).  Выполните команду "docker compose up -d". Прочитайте warning, объясните суть предупреждения и выполните предложенное действие. Погасите тестовый стенд ОДНОЙ(обязательно!!) командой.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод, файл compose.yaml , скриншот portainer c задеплоенным компоузом.

---

### Решение 5

1. Чтобы выполнить данное задание, необходимо поставить версию **docker-compose 2.X.** \
   На 10/01/2024 в репозитории **Ubuntu** последняя версия 1.29.2 без поддержки вложенных дополнительных файлов в манифесте.
2. Обновился до версии **2.2.2** по ссылке: [https://github.com/docker/compose/releases](https://github.com/docker/compose/releases)

![ver](https://github.com/SlavaZakariev/netology/blob/e62e0bda069cf6d6fdd30c70bfda9ea050e8db8e/virtualization-containerization/16.3_docker-compose/resources/dc_5.1.jpg)

3. Запустил команду `docker compose up -d` в папке проекта, по умолчанию запустился манифест под именем **compose.yaml**.

![cont](https://github.com/SlavaZakariev/netology/blob/e62e0bda069cf6d6fdd30c70bfda9ea050e8db8e/virtualization-containerization/16.3_docker-compose/resources/dc_5.2.jpg)

4. Отредактировал файл **compose.yaml** для запуска обоих файлов:

```yaml
version: "3"
include:
  - docker-compose.yaml #Второй файл внутри директории task5
services:
   portainer:
     image: portainer/portainer-ce:latest
     network_mode: host
     ports:
       - "9000:9000"
     volumes:
       - /var/run/docker.sock:/var/run/docker.sock
```
![compose](https://github.com/SlavaZakariev/netology/blob/e91d4cb6364353e894eaede2e204e49c4bd0fd0c/virtualization-containerization/16.3_docker-compose/resources/dc_5.3.jpg)

5. Поставим тэг для ранее созданного снимка контейнера **custom-nginx** и загрузим в локальный репозиторий.

![tah](https://github.com/SlavaZakariev/netology/blob/33fc5b305db6843c7814508180028dfa122d046e/virtualization-containerization/16.3_docker-compose/resources/dc_5.4.jpg)

6. Проверим работоспособность локального репозитория-контейнера.

- Удалим снимок с тэгом **localhost:5000/custom-nginx**
- Загрузим его с локального репозитория
- Проверим наличие снимка localhost:5000/custom-nginx в общем списке загруженных снимков

![check](https://github.com/SlavaZakariev/netology/blob/33fc5b305db6843c7814508180028dfa122d046e/virtualization-containerization/16.3_docker-compose/resources/dc_5.5.jpg)

8. Производим начальную настройку **portainer** логин/пароль администратора.

![portainer1](https://github.com/SlavaZakariev/netology/blob/e91d4cb6364353e894eaede2e204e49c4bd0fd0c/virtualization-containerization/16.3_docker-compose/resources/dc_5.6.jpg)

9. Запускаем **compose** **nginx** через **portainer**.

![portainer1](https://github.com/SlavaZakariev/netology/blob/07968405c7612a6b6cbf52341dee137117a4b80b/virtualization-containerization/16.3_docker-compose/resources/dc_5.7.jpg)

10. Проверяем запущенный контейнер в терминале.

![portainer2](https://github.com/SlavaZakariev/netology/blob/07968405c7612a6b6cbf52341dee137117a4b80b/virtualization-containerization/16.3_docker-compose/resources/dc_5.8.jpg)

11. Снимок контейнера в portainer от от поля **AppArmorProfile** до **Driver**.

![portainer3](https://github.com/SlavaZakariev/netology/blob/07968405c7612a6b6cbf52341dee137117a4b80b/virtualization-containerization/16.3_docker-compose/resources/dc_5.9.jpg)

12. Удаляем **compose.yaml** и запускаем команду `docker compose up -d`. Получаем предупреждение, которое оповещает: \
    Найдены потерянные контейнеры для этого проекта. Описание контейнера **Portainer** было в удалённом файле compose.yaml, можно запустить команду с флагом **--remove- 
    orphans**, чтобы очистить ее.

![compose](https://github.com/SlavaZakariev/netology/blob/07968405c7612a6b6cbf52341dee137117a4b80b/virtualization-containerization/16.3_docker-compose/resources/dc_6.1.jpg)

13. Остановить тестовый стенд можно командой `docker stop $(docker ps -a -q)` под пользователем **root**

![prune](https://github.com/SlavaZakariev/netology/blob/3af654377a29e83e5e18bcba2b08a0989e77fd5c/virtualization-containerization/16.3_docker-compose/resources/dc_6.2.jpg)

