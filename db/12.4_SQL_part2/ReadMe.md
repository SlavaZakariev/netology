## 12.4 SQL. Часть 2 - Вячеслав Закариев

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

---

### Решение 1

Выборка:
- по объединноному столбцу ФИО сотрудника, города и количеству покупателей просуммированые по номеру id из таблицы **store**
- внутренний джоин по id магазина, покупателя, адреса и города
- группировка с помощью оператора **GROUP BY** по id сотрудника
- и фильтрации при помощи оператора **HAVING** у кого более 300 покупателей (по id покупателя)

```sql
select	concat(sf.first_name , ' ', sf.last_name) as 'Full Name Employee',
		cy.city as 'City',
		COUNT(cr.customer_id) as 'Number of Buyers'		
from store s
inner join staff sf on sf.store_id = s.store_id 
inner join customer cr on cr.store_id = s.store_id
inner join address a on a.address_id = s.address_id 
inner join city cy on cy.city_id = a.city_id 
group by sf.staff_id
having COUNT(cr.customer_id) > 300;
```

![sql1](https://github.com/SlavaZakariev/netology/blob/f9997c8e7053d91cb5a8b2e2e9dc297c88eee466/db/12.4_SQL_part2/resources/sql_2.1.jpg)
 
---

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

---

### Решение 2

Выборка:
- сумма фильмов по названию из таблицы **film**
- с дополнительным параметром c помощью оператора **WHERE** по длине фильма **length**
- и функции **AVG** для вычисления среднего арифметического значения, в нашем случае продолжительности фильма

```sql
select COUNT(f.title)
from film f  
where f.`length` > (select AVG(`length`) 
                    from film);
```
![sql2](https://github.com/SlavaZakariev/netology/blob/97221f6c8c48a9d7231312a08112392c2a73a37f/db/12.4_SQL_part2/resources/sql_2.2.jpg)

---

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

---

### Решение 3

Выборка:
- стоббец сумма платежей, 
- с дополнительным параметром c помощью оператора **WHERE** по длине фильма **length**
- и функции **AVG** для вычисления среднего арифметического значения, в нашем случае продолжительности фильма

```sql
select	t.amount_of_payments, t.month_of_payments,
	(select count(r.rental_id)
	from rental r
	where DATE_FORMAT(r.rental_date, '%M %Y') = t.month_of_payments) 'count_of_rent'
from (
  select SUM(p.amount) 'amount_of_payments', DATE_FORMAT(p.payment_date, '%M %Y') 'month_of_payments' 
  from payment p 
  group by DATE_FORMAT(p.payment_date, '%M %Y')) t
order by t.amount_of_payments desc  
limit 1;
```
![sql3]()

