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

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

---

### Решение 2

```sql
select distinct concat(c.last_name, ' ', c.first_name) as 'Full Name', sum(p.amount) over (c.customer_id)
from payment p, customer c
where date(p.payment_date) = '2005-07-30' and p.customer_id = c.customer_id;
```
Результат затрачиваемый до оптимизации запроса
![index2](https://github.com/SlavaZakariev/netology/blob/587fd0d5276dadcc7b7b2a5a437046c24cbea165/db/12.5_indexes/resources/index_1.2.jpg)

Результат затрачиваемый после оптимизации запроса
![index3](https://github.com/SlavaZakariev/netology/blob/587fd0d5276dadcc7b7b2a5a437046c24cbea165/db/12.5_indexes/resources/index_1.3.jpg)

