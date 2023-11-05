## 11.2 Кеширование Redis/Memcached - Вячеслав Закариев

### Задание 1. Кеширование 

Приведите примеры проблем, которые может решить кеширование. 

*Приведите ответ в свободной форме.*

---

### Решение 1

Кэширование необходимо для часто используемых данных, которые чаще всего запрашиваются системой (системы могут быть абсолютно разные).
Ответы на запросы к базам данных могут затрачивать много времени, что приводит к замедлению работы, особенно в пиках. Постоянное повышение системных ресурсов для формирования скорого ответа, достаточно накладно по финансовым расходам и не совсем эффективно при наличии кеширующих инструментов. Можно выделить повторяющие запросы в кэш-инструмент, это существенно помогает сократить время отклика запроса, что в свою очередь увеличивает производительность различных веб-приложений, которые нас окружают сегодня. 

Хотелось бы отменить большую помощь кэш-инструментов на приложениях c графическими элементами, к примеру онлайн-магазины одежды, где размещают фото товаров с большим разрешением для возможности просмотра модели с помощью зум-инструмента в рамках самого-приложения. Частые запросы на графических элементы снижают не только время отклика, но и сетевой трафик, что благоприятно влияет на коллизии.

---

### Задание 2. Memcached

Установите и запустите memcached.

*Приведите скриншот systemctl status memcached, где будет видно, что memcached запущен.*

---

### Решение 2

Установлен memcached, версия 1.6.14

![memcached](https://github.com/SlavaZakariev/netology/blob/ea966278ddec5c5fd5a76ca58f9d71854fb083ba/ds-ts/11.2_redis/resources/cash_1.1.jpg)

---

### Задание 3. Удаление по TTL в Memcached

Запишите в memcached несколько ключей с любыми именами и значениями, для которых выставлен TTL 5. 

*Приведите скриншот, на котором видно, что спустя 5 секунд ключи удалились из базы.*

---

### Решение 3

Выставлен ttl 5 секунд

![ttl5](https://github.com/SlavaZakariev/netology/blob/ea966278ddec5c5fd5a76ca58f9d71854fb083ba/ds-ts/11.2_redis/resources/cash_1.2.jpg)

---

### Задание 4. Запись данных в Redis

Запишите в Redis несколько ключей с любыми именами и значениями. 

*Через redis-cli достаньте все записанные ключи и значения из базы, приведите скриншот этой операции.*

---

Установлен redis

![redis1](https://github.com/SlavaZakariev/netology/blob/ea966278ddec5c5fd5a76ca58f9d71854fb083ba/ds-ts/11.2_redis/resources/cash_1.3.jpg)

Добавлены три ключа

![redis1](https://github.com/SlavaZakariev/netology/blob/ea966278ddec5c5fd5a76ca58f9d71854fb083ba/ds-ts/11.2_redis/resources/cash_1.4.jpg)