## 10.2 Кластеризация и балансировка нагрузки - Вячеслав Закариев

### Задание 1
- Запустите два simple python сервера на своей виртуальной машине на разных портах
- Установите и настройте HAProxy, воспользуйтесь материалами к лекции по [ссылке](https://github.com/netology-code/sflt-homeworks/tree/main/2)
- Настройте балансировку Round-robin на 4 уровне.
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.

---

### Решение 1

1. Конфигурационный файл haproxy.cfg после пункта "default"

```
frontend example  # секция фронтенд
        mode http
        bind :8088
        #default_backend web_servers
	acl ACL_example.com hdr(host) -i example.com
	use_backend web_servers if ACL_example.com

backend web_servers    # секция бэкенд
        mode http
        balance roundrobin
        option httpchk
        http-check send meth GET uri /index.html
        server s1 127.0.0.1:8000 check
        server s2 127.0.0.1:9000 check

listen web_tcp
	bind :1325
	server s1 127.0.0.1:8000 check inter 3s
	server s2 127.0.0.1:9000 check inter 3s
```

2. Настроена балансировка Round-robin

![roundrobin](https://github.com/SlavaZakariev/netology/blob/1c8216bfa5aeb20aaf4da314579a962d33e9db1e/fault-tolerance/10.2_clustering/resources/haproxy_1.1.jpg)

---

### Задание 2
- Запустите три simple python сервера на своей виртуальной машине на разных портах
- Настройте балансировку Weighted Round-robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4
- HAproxy должен балансировать только тот http-трафик, который адресован домену example.local
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.

---

### Решение 2

1. Конфигурационный файл haproxy.cfg после пункта "default"

```
listen stats  # веб-страница со статистикой
        bind                    :888
        mode                    http
        stats                   enable
        stats uri               /stats
        stats refresh           5s
        stats realm             Haproxy\ Statistics

frontend example  # секция фронтенд
        mode http
        bind :8088
        #default_backend web_servers
        acl ACL_example.local hdr(host) -i example.local
        use_backend web_servers if ACL_example.local

backend web_servers    # секция бэкенд
        mode http
        balance roundrobin
        option httpchk
        http-check send meth GET uri /index.html
        server s1 127.0.0.1:8000 weight 2 check
        server s2 127.0.0.1:9000 weight 3 check
        server s3 127.0.0.1:10000 weight 4 check
```

2. Настроена балансировка Weighted Round-robin

![weightroundrobin](https://github.com/SlavaZakariev/netology/blob/8886ce2981977a669223fec6e9fc641b5397e2a9/fault-tolerance/10.2_clustering/resources/haproxy_1.2.jpg)
