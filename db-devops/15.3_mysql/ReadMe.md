## 15.3 MySQL - Вячеслав Закариев

### Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

### Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume. \
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и восстановитесь из него. \
Перейдите в управляющую консоль `mysql` внутри контейнера. \
Используя команду `\h` получите список управляющих команд. \
Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД. \
Подключитесь к восстановленной БД и получите список таблиц из этой БД. \
**Приведите в ответе** количество записей с `price` > 300. \
В следующих заданиях мы будем продолжать работу с данным контейнером.

---

### Решение 1

Подготовлен манифест для docker-compose

```yaml
version: "3.8"

services:
  mysql:
    image: mysql:8
    container_name: netology_mysql
    volumes:
      - netology_mysqldata:/var/lib/mysql
      - ./mysql/test_dump.sql:/dump/test_dump.sql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD:
      MYSQL_DATABASE: mysql
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"

volumes:
  netology_mysqldata: {}
```
Развёрнут контейнер mysql

![mysql1](https://github.com/SlavaZakariev/netology/blob/27be6715466ac026772448fb496145f7342f7d1c/db-devops/15.3_mysql/resources/mysql_1.1.jpg)

Вошли в контейнер, далее в консоль **mysql** и создаём БД netology

![mysql2](https://github.com/SlavaZakariev/netology/blob/27be6715466ac026772448fb496145f7342f7d1c/db-devops/15.3_mysql/resources/mysql_1.2.jpg)

Восстанавливаем дамп test_dump.sql в созданную БД netology

```sql
mysql> netology < /dump/test_dump.sql
```
Выводим версию СУБД

![mysql3](https://github.com/SlavaZakariev/netology/blob/27be6715466ac026772448fb496145f7342f7d1c/db-devops/15.3_mysql/resources/mysql_1.3.jpg)

Подключаемся к восстановленной БД, выводим список таблиц и количество записей с `price` > 300.

![mysql4](https://github.com/SlavaZakariev/netology/blob/0e7bcf97b2b5b4817246edcdf97e01e8a0028c18/db-devops/15.3_mysql/resources/mysql_1.4.jpg)

---

### Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- атрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

---

### Решение 2

Создаём пользователя, согласно условию (пометки в комментариях)

```sql
CREATE USER 'test'@'localhost'
  IDENTIFIED WITH mysql_native_password BY 'test-pass' -- плагин авторизации mysql_native_password
  WITH MAX_QUERIES_PER_HOUR 100 -- максимальное количество запросов в час - 100
  PASSWORD EXPIRE INTERVAL 180 DAY -- срок истечения пароля - 180 дней
  FAILED_LOGIN_ATTEMPTS 3 -- количество попыток авторизации - 3
  ATTRIBUTE '{"fname": "James", "lname": "Pretty"}' -- атрибуты пользователя;
```

Предоставляем привилегии пользователю `test` на операции SELECT базы `test_db`. \
Данные по пользователю с помощью схемы **INFORMATION_SCHEMA.USER_ATTRIBUTES**

```sql
SELECT table_schema, table_name, engine
  FROM information_schema.tables
  WHERE table_name = 'orders';
```

![user2](https://github.com/SlavaZakariev/netology/blob/e403fea16a867a792d39efcf50fb6dd73f402864/db-devops/15.3_mysql/resources/mysql_2.2.jpg)

![user1](https://github.com/SlavaZakariev/netology/blob/e403fea16a867a792d39efcf50fb6dd73f402864/db-devops/15.3_mysql/resources/mysql_2.1.jpg)

---

### Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

---

### Решение 3

Установим профилирование

```sql
SET profiling = 1;
```

Фиксируем время выполнения запроса `SELECT * FROM orders WHERE price > 100;` на движке **InnoDB**

![engine1](https://github.com/SlavaZakariev/netology/blob/478da854dcf4f2c5a7eae5d8c81dcf5d9083d57b/db-devops/15.3_mysql/resources/mysql_3.1.jpg)

Проверка текущего движке **InnoDB**, а также внесение на **MyISAM**

![engine2](https://github.com/SlavaZakariev/netology/blob/478da854dcf4f2c5a7eae5d8c81dcf5d9083d57b/db-devops/15.3_mysql/resources/mysql_3.2.jpg)

Фиксируем время выполнения запроса `SELECT * FROM orders WHERE price > 100;` на движке **MyISAM**

![engine3](https://github.com/SlavaZakariev/netology/blob/478da854dcf4f2c5a7eae5d8c81dcf5d9083d57b/db-devops/15.3_mysql/resources/mysql_3.3.jpg)

Разница во времени выполнения для движков: \
**InnoDB: 0.00017975** \
**MyISAM: 0.00016100**

---

### Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

---

### Решение 4

Выполним копия конфигурационного файла командой

```
cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bakup1
```

Можно внести изменения в виде:

```
innodb_flush_method=O_DSYNC
innodb_flush_log_at_trx_commit=2
innodb_file_per_table=ON
innodb_log_buffer_size=1M
innodb_buffer_pool_size=2G
innodb_log_file_size=100M
```
