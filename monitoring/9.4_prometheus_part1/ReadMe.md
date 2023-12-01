## 9.4 Система мониторинга Prometheus. Часть 1 - Вячеслав Закариев

### Задание 1
Установите Prometheus.

#### Процесс выполнения
1. Выполняя задание, сверяйтесь с процессом, отражённым в записи лекции
2. Создайте пользователя prometheus
3. Скачайте prometheus и в соответствии с лекцией разместите файлы в целевые директории
4. Создайте сервис как показано на уроке
5. Проверьте что prometheus запускается, останавливается, перезапускается и отображает статус с помощью systemctl

#### Требования к результату
* Прикрепите к файлу README.md скриншот systemctl status prometheus, где будет написано: prometheus.service — Prometheus Service Netology Lesson 9.4 — [Ваши ФИО]

---

### Решение 1
Установлен Prometheus.

![prometheus](https://github.com/SlavaZakariev/netology/blob/496f314d80d0d32b36e4976f3914ff4b7c1b3872/monitoring/8.4_prometheus_part1/resources/prometheus_1.1.jpg)

---

### Задание 2
Установите Node Exporter.

#### Процесс выполнения
1. Выполняя ДЗ сверяйтесь с процессом отражённым в записи лекции.
3. Скачайте node exporter приведённый в презентации и в соответствии с лекцией разместите файлы в целевые директории
4. Создайте сервис для как показано на уроке
5. Проверьте что node exporter запускается, останавливается, перезапускается и отображает статус с помощью systemctl

#### Требования к результату
* Прикрепите к файлу README.md скриншот systemctl status node-exporter, где будет написано: node-exporter.service — Node Exporter Netology Lesson 9.4 — [Ваши ФИО]

---

### Решение 1
Установлен Node Exporter.

![node-exporter](https://github.com/SlavaZakariev/netology/blob/496f314d80d0d32b36e4976f3914ff4b7c1b3872/monitoring/8.4_prometheus_part1/resources/prometheus_1.2.jpg)

---

### Задание 3
Подключите Node Exporter к серверу Prometheus.

#### Процесс выполнения
1. Выполняя ДЗ сверяйтесь с процессом отражённым в записи лекции.
2. Отредактируйте prometheus.yaml, добавив в массив таргетов установленный в задании 2 node exporter
3. Перезапустите prometheus
4. Проверьте что он запустился

#### Требования к результату
* Прикрепите к файлу README.md скриншот конфигурации из интерфейса Prometheus вкладки Status > Configuration
* Прикрепите к файлу README.md скриншот из интерфейса Prometheus вкладки Status > Targets, чтобы было видно минимум два эндпоинта

---

Страница конфигурации Prometheus

![configuration](https://github.com/SlavaZakariev/netology/blob/496f314d80d0d32b36e4976f3914ff4b7c1b3872/monitoring/8.4_prometheus_part1/resources/prometheus_1.3.jpg)

Страница объектов Prometheus

![target](https://github.com/SlavaZakariev/netology/blob/496f314d80d0d32b36e4976f3914ff4b7c1b3872/monitoring/8.4_prometheus_part1/resources/prometheus_1.4.jpg)

---
