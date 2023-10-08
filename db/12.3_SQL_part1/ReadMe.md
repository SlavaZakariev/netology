## 12.3 SQL. Часть 1 - Вячеслав Закариев

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.

---

### Решение 1

Выборка по столбцу **district** в таблице **address** с использованием оператора **LIKE** выборки названия и **POSITION** для исключения пробела.

```
SELECT DISTINCT district
FROM address
WHERE district like 'K%a'
      and POSITION(' ' IN district) = 0;
```
![sql1](https://github.com/SlavaZakariev/netology/blob/c2a8c93a415344ce28e22257ea0043021a064225/db/12.3_SQL_part1/resources/sql_1.1.jpg)

---

### Задание 2

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.

---

### Решение 2

Выборка всех строк в таблице **payment** с уточняющими параметрами промежутка даты и величины стоимости.

```
SELECT *
FROM payment
WHERE Date(payment_date) between '2005-06-15' and '2005-06-18'
      and amount > 10.0;
```
![sql2](https://github.com/SlavaZakariev/netology/blob/c2a8c93a415344ce28e22257ea0043021a064225/db/12.3_SQL_part1/resources/sql_1.2.jpg)

---

### Задание 3

Получите последние пять аренд фильмов.

---

### Решение 3

Выборка всех строк в таблице **rental** сортируя с помощью оператора **ORDER BY**, и указанием лимита.

```
SELECT *
FROM rental
ORDER BY rental_date DESC
LIMIT 5;
```
![sql3](https://github.com/SlavaZakariev/netology/blob/c2a8c93a415344ce28e22257ea0043021a064225/db/12.3_SQL_part1/resources/sql_1.3.jpg)

---

### Задание 4

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'.

---

### Решение 4

Выборка с подменой в имени символов 'll' в таблице **customer** с помощью оператора **REPLACE**, и выводом имени с маленькой буквы с помощью оператора **LOWER** и указанием столбца в круглых скобках, а также уточняющие параметры по имени и активности с помощью оператора **WHERE**.

```
SELECT REPLACE(LOWER(first_name), 'll', 'pp'), LOWER(last_name), active
FROM customer
WHERE first_name IN ('Kelly', 'Willie') and active = 1;
```
![sql4](https://github.com/SlavaZakariev/netology/blob/c2a8c93a415344ce28e22257ea0043021a064225/db/12.3_SQL_part1/resources/sql_1.4.jpg)

---
