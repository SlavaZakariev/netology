## 20.2 Средство визуализации Grafana - Вячеслав Закариев

### Задание повышенной сложности

**При решении задания 1** не используйте директорию [help](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/10-monitoring-03-grafana/help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы 
использовали в процессе решения задания.

**При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

### Задание 1

1. Используя директорию [help](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/10-monitoring-03-grafana/help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

### Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);
- CPULA 1/5/15;
- количество свободной оперативной памяти;
- количество места на файловой системе.

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

### Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

### Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.

---

### Решение 1

1. Выполнен [манифест](https://github.com/SlavaZakariev/netology/blob/main/monitoring-devops/20.2_grafana/yaml/docker-compose.yml) в **docker compose**
![docker](https://github.com/SlavaZakariev/netology/blob/d4f1b2e9190862673ad3ad33ed007cc0acd56978/monitoring-devops/20.2_grafana/resources/monit2_1.1.jpg)

2. Заходим на веб-страницу **Grafana**
![grafana](https://github.com/SlavaZakariev/netology/blob/d4f1b2e9190862673ad3ad33ed007cc0acd56978/monitoring-devops/20.2_grafana/resources/monit2_1.2.jpg)

3. Добавлен источник сбора данных Prometheus
![prometheus](https://github.com/SlavaZakariev/netology/blob/d4f1b2e9190862673ad3ad33ed007cc0acd56978/monitoring-devops/20.2_grafana/resources/monit2_1.3.jpg)

### Решение 2

Создал Dashboard и четыре Panels.

1. Утилизация CPU для nodeexporter (в процентах, 100-idle)
```bash
100-(avg by (instance) (rate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[1m]))*100)
```
2. CPU Load Average 1/5/15
```bash
node_load1
node_load5
node_load15
```
3. Количество свободной оперативной памяти (Общее + Используемое)
```bash
avg(node_memory_MemFree_bytes{instance="nodeexporter:9100",job="nodeexporter"})
```
4. Количество места на файловой системе
```bash
node_filesystem_avail_bytes
```

Для этой метрики хотел применить строку ниже под наш exporter, но данные не выдавались в график:
`node_filesystem_free_bytes{fstype="et4",instance="nodeexporter:9100",job="nodeexporter"}`

![finish](https://github.com/SlavaZakariev/netology/blob/5ef2c1118662fb6e22f6deef6eb33cf2a40c7c3e/monitoring-devops/20.2_grafana/resources/monit2_1.4.jpg)

