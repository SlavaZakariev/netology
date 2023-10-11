## 12.5 Индексы - Вячеслав Закариев

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

---

### Решение 1

```sql
SELECT SUM(DATA_LENGTH) as 'Quantity of Tables', SUM(INDEX_LENGTH) as 'Quantity of Indexes,
       ROUND(SUM(INDEX_LENGTH)*100/SUM(DATA_LENGTH) as 'Indexes in %'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'sakila';
```
![index1](https://github.com/SlavaZakariev/netology/blob/587fd0d5276dadcc7b7b2a5a437046c24cbea165/db/12.5_indexes/resources/index_1.1.jpg)

---

### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

---

### Решение 2

1. Добавлено название столбца **Full Name** для удобства чтения вывода склеенных таблиц
2. При подсчёте суммы платежей нет необходимости включать столбец **f.title**, достаточно **id** покупателя
3. Так как результат до оптимизации выводит столбцы имя покупателя и плати, то выборку из списка таблиц можно сократить до необходимых нам **payment** и **customer**
4. Дополнительные параметры в зоне оператора **WHERE** тоже сокращены, оставлена указанная ранее даты без измененний, изменено сопоставление между **id** покупателей в таблицах **payment** и **customer**. Ранее мы сократили выборку из списка таблиц, соответственно убрали остальные параметры.

```sql
select distinct concat(c.last_name, ' ', c.first_name) as 'Full Name', sum(p.amount) over (c.customer_id)
from payment p, customer c
where date(p.payment_date) = '2005-07-30' and p.customer_id = c.customer_id;
```
Результат затрачиваемый до оптимизации запроса **(2,4 секунды)**
![index2](https://github.com/SlavaZakariev/netology/blob/587fd0d5276dadcc7b7b2a5a437046c24cbea165/db/12.5_indexes/resources/index_1.2.jpg)

Результат затрачиваемый после оптимизации запроса **(4 миллисекунды)**
![index3](https://github.com/SlavaZakariev/netology/blob/587fd0d5276dadcc7b7b2a5a437046c24cbea165/db/12.5_indexes/resources/index_1.3.jpg)

