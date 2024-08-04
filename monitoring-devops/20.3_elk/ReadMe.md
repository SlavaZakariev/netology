## 20.3 Система сбора логов Elastic Stack - Вячеслав Закариев

### Дополнительные ссылки

При выполнении задания используйте дополнительные ресурсы:

- [поднимаем elk в docker](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-docker.html);
- [поднимаем elk в docker с filebeat и docker-логами](https://www.sarulabs.com/post/5/2019-08-12/sending-docker-logs-to-elasticsearch-and-kibana-with-filebeat.html);
- [конфигурируем logstash](https://www.elastic.co/guide/en/logstash/current/configuration.html);
- [плагины filter для logstash](https://www.elastic.co/guide/en/logstash/current/filter-plugins.html);
- [конфигурируем filebeat](https://www.elastic.co/guide/en/beats/libbeat/5.3/config-file-format.html);
- [привязываем индексы из elastic в kibana](https://www.elastic.co/guide/en/kibana/current/index-patterns.html);
- [как просматривать логи в kibana](https://www.elastic.co/guide/en/kibana/current/discover.html);
- [решение ошибки increase vm.max_map_count elasticsearch](https://stackoverflow.com/questions/42889241/how-to-increase-vm-max-map-count).

### Задание 1

Вам необходимо поднять в докере и связать между собой:

- elasticsearch (hot и warm ноды);
- logstash;
- kibana;
- filebeat.

Logstash следует сконфигурировать для приёма по tcp json-сообщений.

Filebeat следует сконфигурировать для отправки логов docker вашей системы в logstash.

В директории [help](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/10-monitoring-04-elk/help) находится манифест docker-compose и конфигурации filebeat/logstash для быстрого 
выполнения этого задания.

Результатом выполнения задания должны быть:

- скриншот `docker ps` через 5 минут после старта всех контейнеров (их должно быть 5);
- скриншот интерфейса kibana;
- docker-compose манифест (если вы не использовали директорию help);
- ваши yml-конфигурации для стека (если вы не использовали директорию help).

### Задание 2

Перейдите в меню [создания index-patterns  в kibana](http://localhost:5601/app/management/kibana/indexPatterns/create) и создайте несколько index-patterns из имеющихся.

Перейдите в меню просмотра логов в kibana (Discover) и изучите, как отображаются логи и как производить поиск по логам.

В манифесте директории help также приведенно dummy-приложение, которое генерирует рандомные события в stdout-контейнера.
Эти логи должны порождать индекс logstash-* в elasticsearch. Если этого индекса нет — воспользуйтесь советами и источниками из раздела «Дополнительные ссылки» этого задания.
 
---

### Решение 1

Изменён манифест из папки [help](https://github.com/SlavaZakariev/netology/blob/main/monitoring-devops/20.3_elk/yaml/docker-compose.yml) добавлены пара переменных, изменены версии, сеть, статические IP и другие мелкие элементы.

![docker1](https://github.com/SlavaZakariev/netology/blob/3767b1ca7bce4892311252dc4347adc83f1ad857/monitoring-devops/20.3_elk/resources/monit3_1.1.jpg)

Запуск команды `docker ps` спустя 5 минут, согласно условию задания

![docker2](https://github.com/SlavaZakariev/netology/blob/3767b1ca7bce4892311252dc4347adc83f1ad857/monitoring-devops/20.3_elk/resources/monit3_1.2.jpg)

Запуск начальной страницы Kibana

![kibana](https://github.com/SlavaZakariev/netology/blob/3767b1ca7bce4892311252dc4347adc83f1ad857/monitoring-devops/20.3_elk/resources/monit3_1.3.jpg)

### Решение 2

Создан **data view**, указан **logstash-***

![log1](https://github.com/SlavaZakariev/netology/blob/3767b1ca7bce4892311252dc4347adc83f1ad857/monitoring-devops/20.3_elk/resources/monit3_1.4.jpg)

Отображение списка лога по временной шкале

![log2](https://github.com/SlavaZakariev/netology/blob/3767b1ca7bce4892311252dc4347adc83f1ad857/monitoring-devops/20.3_elk/resources/monit3_1.5.jpg)
