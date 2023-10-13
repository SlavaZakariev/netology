## 12.5 Индексы - Вячеслав Закариев

### Задание 1

Напишите запрос к БД, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

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
2. Выборку из списка таблиц можно сократить до **payment**
3. Добавлены два внутренних джоина для сопоставления даты и покупателей по **id**
4. Дополнительные параметры в зоне оператора **WHERE** тоже сокращены, оставлена указанная ранее дата с указанием полных суток
5. Добавлена групировка по **id** покупателя

```sql
select concat(c.last_name, ' ', c.first_name) as 'Full Name', sum(p.amount)
from payment p
inner join rental r on r.rental_date = p.payment_date
inner join customer c on c.customer_id = r.customer_id 
where p.payment_date between '2005-07-30 00:00:00' and '2005-07-30 23:59:59'
group by c.customer_id  
```

![index2](https://github.com/SlavaZakariev/netology/blob/07eaecc2246fcfa735e545b055ed9e38787def26/db/12.5_indexes/resources/index_1.4.jpg)
