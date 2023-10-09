## 12.4 SQL. Часть 2 - Вячеслав Закариев

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

---

### Решение 1

```
select	concat(sf.first_name , ' ', sf.last_name) as 'LFMname Employee',
		cy.city,
		COUNT(cr.customer_id) as 'Count Buyers'		
from store s
join staff sf on sf.store_id = s.store_id 
join customer cr on cr.store_id = s.store_id
join address a on a.address_id = s.address_id 
join city cy on cy.city_id = a.city_id 
group by sf.staff_id, cy.city_id 
having COUNT(cr.customer_id) > 300;
```

![sql1](https://github.com/SlavaZakariev/netology/blob/dd6858cda563ffdaf9a2721b5e737e5f845c91ef/db/12.4_SQL_part2/resources/sql_2.1.jpg)
 
---

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

---

### Решение 2
```
select COUNT(f.title)
from film f  
where f.`length` > (select AVG(`length`) 
                    from film);
```
![sql2](https://github.com/SlavaZakariev/netology/blob/dd6858cda563ffdaf9a2721b5e737e5f845c91ef/db/12.4_SQL_part2/resources/sql_2.2.jpg)

---

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

---

### Решение 3

```
select	t.amount_of_payments,
	t.month_of_payments,
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
![sql3](https://github.com/SlavaZakariev/netology/blob/dd6858cda563ffdaf9a2721b5e737e5f845c91ef/db/12.4_SQL_part2/resources/sql_2.3.jpg)

