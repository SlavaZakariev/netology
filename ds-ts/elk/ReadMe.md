## 11.3 ELK - Вячеслав Закариев

### Задание 1. Elasticsearch 

Установите и запустите Elasticsearch, после чего поменяйте параметр cluster_name на случайный. 

*Приведите скриншот команды 'curl -X GET 'localhost:9200/_cluster/health?pretty', сделанной на сервере с установленным Elasticsearch. Где будет виден нестандартный cluster_name*.

---

### Решение 1

<details>
   <summary> Конфигурационный файл docker-compose.yaml для 4-х контейнеров. </summary>

```
version: '3.7'

services:
  # Elasticsearch Docker Images: https://www.docker.elastic.co/
  elasticsearch:
    image: elasticsearch:7.17.9
    container_name: elasticsearch
    environment:
      - xpack.security.enabled=false
      - discovery.type=single-node
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    cap_add:
      - IPC_LOCK
    volumes:
      - elasticsearch-data:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
      - 9300:9300

  kibana:
    container_name: kibana
    image: kibana:7.17.9
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - 5601:5601
    depends_on:
      - elasticsearch

  filebeat:
    image: docker.elastic.co/beats/filebeat:7.17.9
    command: --strict.perms=false
    user: root
    volumes:
      - /root/projects/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - /var/lib/docker:/var/lib/docker:ro
      - /var/run/docker.sock:/var/run/docker.sock

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - /var/www/html:/usr/share/nginx/html
    restart: always

volumes:
  elasticsearch-data:
    driver: local

```
</details>

Подняты четыре контейнера.

![docker](https://github.com/SlavaZakariev/netology/blob/a324eda2228c130c94fc2c714997cf157b98bd05/ds-ts/elk/resources/ELK_1.1.jpg)


Веб страница **elasticsearch**.

![elastic](https://github.com/SlavaZakariev/netology/blob/a324eda2228c130c94fc2c714997cf157b98bd05/ds-ts/elk/resources/ELK_1.2.jpg)

---

### Задание 2. Kibana

Установите и запустите Kibana.

*Приведите скриншот интерфейса Kibana на странице http://<ip вашего сервера>:5601/app/dev_tools#/console, где будет выполнен запрос GET /_cluster/health?pretty*.

---

### Решение 2

В Kibana выполнен запрос **GET /_cluster/health?pretty**

![kibana](https://github.com/SlavaZakariev/netology/blob/a324eda2228c130c94fc2c714997cf157b98bd05/ds-ts/elk/resources/ELK_1.3.jpg)

---

### Задание 3. Logstash

Установите и запустите Logstash и Nginx. С помощью Logstash отправьте access-лог Nginx в Elasticsearch. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx.*

---

### Решение 3

![logstash](https://github.com/SlavaZakariev/netology/blob/164ed6f6916d9159c2c9656a6e698722f8f9e683/ds-ts/elk/resources/ELK_1.4.jpg)

---

### Задание 4. Filebeat. 

Установите и запустите Filebeat. Переключите поставку логов Nginx с Logstash на Filebeat. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx, которые были отправлены через Filebeat.*

---

### Решение 4

![filebeat](https://github.com/SlavaZakariev/netology/blob/164ed6f6916d9159c2c9656a6e698722f8f9e683/ds-ts/elk/resources/ELK_1.5.jpg)

---

## Дополнительные ресурсы

При выполнении задания используйте дополнительные ресурсы:
- [docker-compose elasticsearch + kibana](https://github.com/netology-code/sdb-homeworks/blob/main/11-03/docker-compose.yaml);
- [поднимаем elk в docker](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docker.html);
- [поднимаем elk в docker с filebeat и docker-логами](https://www.sarulabs.com/post/5/2019-08-12/sending-docker-logs-to-elasticsearch-and-kibana-with-filebeat.html);
- [конфигурируем logstash](https://www.elastic.co/guide/en/logstash/7.17/configuration.html);
- [плагины filter для logstash](https://www.elastic.co/guide/en/logstash/current/filter-plugins.html);
- [конфигурируем filebeat](https://www.elastic.co/guide/en/beats/libbeat/5.3/config-file-format.html);
- [привязываем индексы из elastic в kibana](https://www.elastic.co/guide/en/kibana/7.17/index-patterns.html);
- [как просматривать логи в kibana](https://www.elastic.co/guide/en/kibana/current/discover.html);
- [решение ошибки increase vm.max_map_count elasticsearch](https://stackoverflow.com/questions/42889241/how-to-increase-vm-max-map-count).
