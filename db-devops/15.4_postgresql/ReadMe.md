## 15.4 PostgreSQL - Вячеслав Закариев

### Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume. \
Подключитесь к БД PostgreSQL используя `psql`. \
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

---

### Решение 1 

Написан манифест **docker-compose.yml**

```yaml
version: "3.8"

services:
  postgres:
    image: postgres:13
    container_name: netology_postgresql
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./postgresql/test_dump.sql:/dump/test_dump.sql
    environment:
      POSTGRES_PASSWORD: netology # пароль для суперпользователя postgres по умолчанию
    restart: always
    ports:
      - 5432:5432

volumes:
  pgdata: {}
```

Развёрнут контейнер PosgreSQL 13

![psql1](https://github.com/SlavaZakariev/netology/blob/ea43db8298860139f4de431d67695266285cfd9c/db-devops/15.4_postgresql/resources/psql_1.1.jpg)

`\l` вывод списка БД \
`\c` подключение к БД \
`\d` вывод списка таблиц \
`\d name` вывод описания содержимого таблицы, где **name** это имя требуемой таблицы \
`\q` выход из psql

---

### Задача 2

Используя `psql` создайте БД `test_database`. \
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data). \
Восстановите бэкап БД в `test_database`. \
Перейдите в управляющую консоль `psql` внутри контейнера. \
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице. \
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders`
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

---

### Решение 2

Создаём БД **test_database** командой:
```sql
CREATE DATABASE test_database;
```

![sql](https://github.com/SlavaZakariev/netology/blob/cade76dca4f8446394cde36dc1a9b6f5a7f46b18/db-devops/15.4_postgresql/resources/psql_1.2.jpg)

Выходим из СУБД в контейнер и восстанавливаем **dump** учитывая ранее примапленную папку контейнера:

```
psql -U postgres test_database < /dump/test_dump.sql
```

Подлючаемся к ранее созданной БД **test_database** и проверям наличие восстановленных данных

![dump](https://github.com/SlavaZakariev/netology/blob/cade76dca4f8446394cde36dc1a9b6f5a7f46b18/db-devops/15.4_postgresql/resources/psql_1.3.jpg)

 Проводим операцию ANALYZE согласно условию для сбора статистики по таблице. \
 Далее вводим запрос для поиска наибольшего среднего значения размера элементов в байтах

![analyze](https://github.com/SlavaZakariev/netology/blob/cade76dca4f8446394cde36dc1a9b6f5a7f46b18/db-devops/15.4_postgresql/resources/psql_1.4.jpg)

```sql
select tablename, attname, avg_width
  from pg_stats
  where tablename = 'orders';
```

---

### Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции. \
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

---

### Решение 3

Можно попробовать создать две таблицы **orders_1** и **orders_2**.

```sql
CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
INSERT INTO orders_1 SELECT * FROM orders where price > 499; -- orders_1: price>499
```
```sql
CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);
INSERT INTO orders_2 SELECT * FROM orders where price <= 499; -- orders_2: price<=499
```
---

### Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`. \
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

### Решение 4

---
