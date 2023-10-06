## 12.2 Работа с данными (DDL/DML) - Вячеслав Закариев

### Задание 1

1.1. Поднимите чистый инстанс MySQL версии 8.0+. Можно использовать локальный сервер или контейнер Docker.

1.2. Создайте учётную запись sys_temp. 

1.3. Выполните запрос на получение списка пользователей в базе данных. (скриншот)

1.4. Дайте все права для пользователя sys_temp. 

1.5. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)

1.6. Переподключитесь к базе данных от имени sys_temp.

Для смены типа аутентификации с sha2 используйте запрос: 
```sql
ALTER USER 'sys_test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
```
1.7. По ссылке https://downloads.mysql.com/docs/sakila-db.zip скачайте дамп базы данных.

1.8. Восстановите дамп в базу данных.

1.9. При работе в IDE сформируйте ER-диаграмму получившейся базы данных. При работе в командной строке используйте команду для получения всех таблиц базы данных. (скриншот)

*Результатом работы должны быть скриншоты обозначенных заданий, а также простыня со всеми запросами.*

---

### Решение 1

1.1 Поднят MySql 8.0.34

![version](https://github.com/SlavaZakariev/netology/blob/36e710a7b641b43de618002ede2e6f9b79ab72e7/db/12.2_ddl-dml/resources/mysql_1.1.jpg)

1.2 Создана учётная запись sys_temp

![account](https://github.com/SlavaZakariev/netology/blob/36e710a7b641b43de618002ede2e6f9b79ab72e7/db/12.2_ddl-dml/resources/mysql_1.2.jpg)

1.3 Список пользователей

![list](https://github.com/SlavaZakariev/netology/blob/36e710a7b641b43de618002ede2e6f9b79ab72e7/db/12.2_ddl-dml/resources/mysql_1.3.jpg)

1.4 Выданы все права для пользователя sys_temp

![grand](https://github.com/SlavaZakariev/netology/blob/36e710a7b641b43de618002ede2e6f9b79ab72e7/db/12.2_ddl-dml/resources/mysql_1.4.jpg)

1.5 Запрос на получение списка прав для пользователя sys_temp

![check_grand](https://github.com/SlavaZakariev/netology/blob/36e710a7b641b43de618002ede2e6f9b79ab72e7/db/12.2_ddl-dml/resources/mysql_1.5.jpg)

1.6 Задан пароль для пользователя sys_temp

![password](https://github.com/SlavaZakariev/netology/blob/36e710a7b641b43de618002ede2e6f9b79ab72e7/db/12.2_ddl-dml/resources/mysql_1.6.jpg)

   - Выход из-под root и вход под sys_temp

![change_user](https://github.com/SlavaZakariev/netology/blob/36e710a7b641b43de618002ede2e6f9b79ab72e7/db/12.2_ddl-dml/resources/mysql_1.7.jpg)

   - Проверка текущего пользователя

![check_user](https://github.com/SlavaZakariev/netology/blob/36e710a7b641b43de618002ede2e6f9b79ab72e7/db/12.2_ddl-dml/resources/mysql_1.8.jpg)

1.7 Скачан архив

![wget](https://github.com/SlavaZakariev/netology/blob/14f858b2a4f724973f2ef03f923b1ee27aca3949/db/12.2_ddl-dml/resources/mysql_1.9.jpg)

1.8 Восстановлен дамп

![wget](https://github.com/SlavaZakariev/netology/blob/14f858b2a4f724973f2ef03f923b1ee27aca3949/db/12.2_ddl-dml/resources/mysql_1.10.jpg)

1.9 Подключение к БД через DBeaver

![DBeaver](https://github.com/SlavaZakariev/netology/blob/440010769c1c46a6b223431e6a7803ba1234a85b/db/12.2_ddl-dml/resources/mysql_1.11.jpg)

---

### Задание 2

Составьте таблицу, используя любой текстовый редактор или Excel, в которой должно быть два столбца: в первом должны быть названия таблиц восстановленной базы, во втором названия первичных ключей этих таблиц. Пример: (скриншот/текст)
```
Название таблицы | Название первичного ключа
customer         | customer_id
```

---

### Решение 2

![tables](https://github.com/SlavaZakariev/netology/blob/b75e33b608cda3b54de8708ec97430824beb1204/db/12.2_ddl-dml/resources/mysql_2.1.jpg
 
---
