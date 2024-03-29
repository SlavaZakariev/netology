## 12.6 Репликация и масштабирование. Часть 1 - Вячеслав Закариев

## Задание 1

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

*Ответить в свободной форме.*

---

## Решение 1

### 1. Master-Slave

- Чтение данных может происходит с slave БД, а на master идёт запись и последующая репликация новых данных на slave БД
- В случае сбоя, slave должен быть повышен до уровня master вручную, так как не предусмотрен автоматическое переключение при отказе master БД
- Отсутствие автоматического переключение при сбое, влечёт за собой простой и возможно потерю данных в отрезке незавершённой репликации на slave БД
- Каждая дополнительная slave БД добавляет нагрузку на master, так как необходимо читать двоичный журнал и копировать данные на каждую slave БД
- Есть вероятность потребности в перезапуске приложения, которое использует БД после переключения.

### 2. Master-Master

- Данные в БД могут считываться с обоих master БД, а также записывать данные в любую master БД
- Распределяет нагрузку записи между обоими master узлами, что увеличивает пропускную способность данных
- При аварии, автоматически и быстро переключается.

---

## Задание 2

Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*

---

## Решение 2

Инфраструктура подготовлена с помощью **docker compose**

1. Подготовлен файл для переменных **.env**
2. Подготовлены 2 тома с конфигурационными файлами **.comf** для контейнеров master и slave
3. Написан манифест для **docker compose**

```yml
version: '3.5'
services:
  replication-master:
    image: mysql:latest
    container_name: replication-master
    restart: always
    env_file: .env
    cap_add:
      - all
    volumes:
      - ./master/my.conf:/etc/mysql/my.cnf
    environment:
      - TZ:${TZ}
      - MYSQL_USER:${MYSQL_USER}
      - MYSQL_PASSWORD:${MYSQL_PASSWORD}
      - MYSQL_ROOT_PASSWORD:${MYSQL_ROOT_PASSWORD}
    networks:
      - mysql

  replication-slave:
    image: mysql:latest
    container_name: replication-slave
    restart: always
    env_file: .env
    cap_add:
      - all
    volumes:
      -  ./slave/my.conf:/etc/mysql/my.cnf
    environment:
      - TZ:${TZ}
      - MYSQL_USER:${MYSQL_USER}
      - MYSQL_PASSWORD:${MYSQL_PASSWORD}
      - MYSQL_ROOT_PASSWORD:${MYSQL_ROOT_PASSWORD}
    networks:
      - mysql

networks:
  mysql:
    name: mysql
```

Результат запуска манифеста, создание 2-х контейнеров **replication-master** и **replication-slave**, а также сеть **mysql**

![compose](https://github.com/SlavaZakariev/netology/blob/5347f9f4201cf0c3d4a07d31a64dd589cd97606e/db/12.6_replication_part1/resources/repl_1.1.jpg)

Запущенные 2 контейнера

![cont](https://github.com/SlavaZakariev/netology/blob/e35056a6aabf2f6d1829d6239c9014d152677a36/db/12.6_replication_part1/resources/repl_1.2.jpg)

Вход на **master**, выдача прав для пользователя **replication**, и проверка **master status**

![master1](https://github.com/SlavaZakariev/netology/blob/86a096ab88ba36cd5c70fbebcf59dcc1bd2feda0/db/12.6_replication_part1/resources/repl_1.3.jpg)

Вход на **slave**, указываем параметры для синхронизации с **master**, и проверка применения внесенных данных **master status**

![slave1](https://github.com/SlavaZakariev/netology/blob/86a096ab88ba36cd5c70fbebcf59dcc1bd2feda0/db/12.6_replication_part1/resources/repl_1.4.jpg)

Создание на **master** базы данных **repl01** для проверки синхронизации с **slave**

![master2](https://github.com/SlavaZakariev/netology/blob/86a096ab88ba36cd5c70fbebcf59dcc1bd2feda0/db/12.6_replication_part1/resources/repl_1.5.jpg)

Проверка на **slave** репликации базы данных **repl01** c **master**

![slave2](https://github.com/SlavaZakariev/netology/blob/86a096ab88ba36cd5c70fbebcf59dcc1bd2feda0/db/12.6_replication_part1/resources/repl_1.6.jpg)

---
