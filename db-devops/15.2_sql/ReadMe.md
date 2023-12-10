## 15.2 SQL - Вячеслав Закариев

### Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

### Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

---

### Решение 1

Разворачиваем 2 контейнера **netology_psql** и **netology_psql_copy** с помощью **docker-compose**:

![sql](https://github.com/SlavaZakariev/netology/blob/1b98ea7035e41481d5f76080620891b4a85662a1/db-devops/15.2_sql/resources/sql_1.1.jpg)

<details>
<summary>docker-compose - файл дополнен с учётом всех заданий ниже</summary>
 
 ```yaml
 # version: "3.8"

services:
  postgres:
    image: postgres:12
    container_name: netology_psql
    volumes:
      - netology_pgdata:/var/lib/postgresql/data
      - netology_pgbackup:/dump
      - ./sql/create.sql:/docker-entrypoint-db/create.sql
      - ./sql/insert.sql:/docker-entrypoint-db/insert.sql
      - ./sql/update.sql:/docker-entrypoint-db/update.sql
    restart: always
    environment:
      POSTGRES_DB: psqldb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres

  postgres_copy:
    image: postgres:12
    container_name: netology_psqsl_copy
    volumes:
      - netology_pgdata_copy:/var/lib/postgresql/data
      - netology_pgbackup:/dump
    restart: always
    environment:
      POSTGRES_DB: psqldb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres

volumes:
  netology_pgdata: {}
  netology_pgbackup: {}
  netology_pgdata_copy: {}
```
</details>

---

### Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

---

### Решение 2

Вошли в контейнер и далее в СУБД с помощью команды: `sudo docker exec -it netology_psql bash -c "psql -U postgres"`

Применили примонтированный скрипт на томе для создания БД, таблиц, пользователя и выдачи им прав согласно условию задания.

<details>
<summary>create.sql</summary>

 ```sql
-- Создание БД test_db
CREATE DATABASE test_db;
\c test_db;

-- Создание в test_db таблицы Orders
CREATE TABLE IF NOT EXISTS Orders (
    order_id SERIAL NOT NULL,
    name varchar(256) NOT NULL,
    price INT,
    PRIMARY KEY (order_id)
);

-- Создание таблицы Clients
CREATE TABLE IF NOT EXISTS Clients (
    client_id SERIAL NOT NULL,
    last_name varchar(256) NOT NULL,
    country_name varchar(256) NOT NULL,
    order_id INT,
    PRIMARY KEY (client_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- предоставление привилигированных прав пользователю test-admin-user на таблицы БД test_db
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA "public" TO "test-admin-user";

-- создание пользователя test-simple-user
CREATE USER "test-simple-user";

-- права пользователю test-simple-user на read/write для таблиц БД test_db
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "public" TO "test-simple-user";
```
</details>

Список БД:

![DBs](https://github.com/SlavaZakariev/netology/blob/f8ab9b7b519cc82126943670defac59c4a3a4607/db-devops/15.2_sql/resources/sql_1.2.jpg)

Описание таблиц **orders** и **clients**:

```sql
test_db-# \d orders
                                        Table "public.orders"
  Column  |          Type          | Collation | Nullable |                 Default
----------+------------------------+-----------+----------+------------------------------------------
 order_id | integer                |           | not null | nextval('orders_order_id_seq'::regclass)
 name     | character varying(256) |           | not null |
 price    | integer                |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (order_id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)

test_db-# \d clients
                                          Table "public.clients"
    Column    |          Type          | Collation | Nullable |                  Default
--------------+------------------------+-----------+----------+--------------------------------------------
 client_id    | integer                |           | not null | nextval('clients_client_id_seq'::regclass)
 last_name    | character varying(256) |           | not null |
 country_name | character varying(256) |           | not null |
 order_id     | integer                |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (client_id)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)

```


---

### Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 

Приведите в ответе:
- запросы
- результаты их выполнения.

---

### Решение 3

---

### Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

---

### Решение 4

---

### Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

---

### Решение 5

---

### Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

### Решение 6

---
