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

Разворачиваем 2 контейнера **netology_psql** и **netology_psqsl_copy** с помощью **docker-compose**:

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

SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
SELECT table_name, grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name IN ('clients', 'orders')
  AND grantee <> 'postgres';
```

Список пользователей с правами над таблицами test_db

```sql
 table_name |     grantee      | privilege_type
------------+------------------+----------------
 orders     | test-admin-user  | INSERT
 orders     | test-admin-user  | SELECT
 orders     | test-admin-user  | UPDATE
 orders     | test-admin-user  | DELETE
 orders     | test-admin-user  | TRUNCATE
 orders     | test-admin-user  | REFERENCES
 orders     | test-admin-user  | TRIGGER
 orders     | test-simple-user | INSERT
 orders     | test-simple-user | SELECT
 orders     | test-simple-user | UPDATE
 orders     | test-simple-user | DELETE
 clients    | test-admin-user  | INSERT
 clients    | test-admin-user  | SELECT
 clients    | test-admin-user  | UPDATE
 clients    | test-admin-user  | DELETE
 clients    | test-admin-user  | TRUNCATE
 clients    | test-admin-user  | REFERENCES
 clients    | test-admin-user  | TRIGGER
 clients    | test-simple-user | INSERT
 clients    | test-simple-user | SELECT
 clients    | test-simple-user | UPDATE
 clients    | test-simple-user | DELETE
(22 rows)
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

Применили примонтированный скрипт **insert.sql** на томе при создании контейнеров.

![insert](https://github.com/SlavaZakariev/netology/blob/ffa20f355576ecea8aa5cd0713362f75d44dbacb/db-devops/15.2_sql/resources/sql_1.3.jpg)

 ```sql
\c test_db;

INSERT INTO Orders (name, price)
VALUES ('Шоколад', 10),
       ('Принтер', 3000),
       ('Книга', 500),
       ('Монитор', 7000),
       ('Гитара', 4000);

INSERT INTO Clients (last_name, country_name)
VALUES ('Иванов Иван Иванович', 'USA'),
       ('Петров Петр Петрович', 'Canada'),
       ('Иоганн Себастьян Бах', 'Japan'),
       ('Ронни Джеймс Дио', 'Russia'),
       ('Ritchie Blackmore', 'Russia');
```

Результат выполнения запроса.

![sql1.5](https://github.com/SlavaZakariev/netology/blob/9401857893de1c5fb2c508f05d5ab29e5b4ad3a3/db-devops/15.2_sql/resources/sql_1.5.jpg)

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
 
Подсказка - используйте директиву `UPDATE`.

---

### Решение 4

Применили примонтированный скрипт **update.sql** на томе при создании контейнеров.

![insert](https://github.com/SlavaZakariev/netology/blob/ffa20f355576ecea8aa5cd0713362f75d44dbacb/db-devops/15.2_sql/resources/sql_1.4.jpg)

```sql
\c test_db;

UPDATE Clients
SET order_id = 3
WHERE client_id = 1;

UPDATE Clients
SET order_id = 4
WHERE client_id = 2;

UPDATE Clients
SET order_id = 5
WHERE client_id = 3;
```

```sql
SELECT * from clients where order_id is not null;
```

![orders](https://github.com/SlavaZakariev/netology/blob/722ab321b143709b640c69243d5e2f69ce20c173/db-devops/15.2_sql/resources/sql_1.6.jpg)

---

### Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

---

### Решение 5

```sql
test_db=# EXPLAIN SELECT * from clients where order_id is not null;
                         QUERY PLAN
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..10.70 rows=70 width=1040)
   Filter: (order_id IS NOT NULL)
(2 rows)
```
![explain](https://github.com/SlavaZakariev/netology/blob/b63554c70cae724745e9bd770f16b9e3e4e351e5/db-devops/15.2_sql/resources/sql_1.7.jpg)

- **Seq Scan** - последовательное чтение данных
- **cost** - время затраченное на выполнение операции
- rows - количество строк при выполнении операции
- width - средний размер одной строки в байтах
- EXPLAIN - команда выводит план выполнения, генерируемый планировщиком PostgreSQL для заданного оператора

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
