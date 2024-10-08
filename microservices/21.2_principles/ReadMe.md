## 21.2 Микросервисы: принципы - Вячеслав Закариев

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

### Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

Обоснуйте свой выбор.

---

### Решение 1

Для оценки выбраны следующие API-шлюзы:
1. **Kong** - один из популярных облачный API-шлюзов с открытым исходным кодом, построенный поверх облегченного прокси.
2. **KrakenD** - высокопроизводительный API-шлюз с открытым исходным кодом.
3. **Tyk** - API-шлюз с открытым исходным кодом на выбор: автономный или управляемый.
4. **Nginx** - производительный, масштабируемый, также используется в качестве API gateway благодаря возможностям настройки.
5. **Gloo Edge** - многофункциональный встроенный в Kubernetes входной контроллер и API-шлюз.


| Правило сравнения      |             Kong            |           KrakenD           |          Tyk            |        Nginx         |        Gloo Edge        |
|------------------------|-----------------------------|-----------------------------|-------------------------|----------------------|-------------------------|
| Язык разработки        | Lua                         | Go                          | Go                      | C                    | Go                      |
| Аутентификация         | Есть                        | Есть                        | Есть                    | Есть                 | Есть                    |
| Терминация HTTPS       | Есть                        | Есть                        | Есть                    | Есть                 | Есть                    |
| Композиция данных      | Нет                         | Есть                        | Есть                    | Нет                  | Нет                     |
| База данных            | PostgreSQL                  | Собственная БД              | Redis                   | Файловое             | Собственная БД          |
| GraphQL                | Есть                        | Есть                        | Есть                    | Нет                  | Есть                    |

Подбор шлюза согласно задаче:
1. Для простых задач вполне подойдет Nginx, данный продукт имеет в арсенале возможности балансировки трафика, терминацию https и проверку аутентификации.
2. Для высоконагруженных систем, требующих обработки большого объёма трафика, подойдёт KrakenD. Продукт имеет богатый функционал, а также на сегодняшний день имеет самую большую производительность из известных API-шлюзов.
3. Также имеется платные варианты шлюзов у облачных провайдеров в виде отдельной услуги AWS, Azure и Yandex, которые показали свою эффективность в работе с облачными сервисами.

---

### Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

---

### Решение 2

| Брокер сообщений | Поддержка кластеризации | Хранение сообщений | Скорость работы | Поддержка форматов сообщений | Разделение прав доступа | Простота эксплуатации |
|------------------|-------------------------|--------------------|-----------------|------------------------------|-------------------------|-----------------------|
| **Apache Kafka** | Есть                    | Есть               | Высокая         | JSON, Avro, Protobuf, Binary | Есть                    | Средняя               |
| **RabbitMQ**     | Есть                    | Есть               | Средняя         | JSON, XML, AMQP, MQTT        | Есть                    | Высокая               |
| **ActiveMQ**     | Есть                    | Есть               | Средняя         | JSON, XML, SOAP, STOMP       | Есть                    | Средняя               |
| **Redis**        | Есть                    | Нет                | Высокая         | JSON, Strings, Lists, Hashes | Нет                     | Высокая               |

Предпочтение оставлю за двумя продуктами, это **Kafka** и **RabbitMQ**. 

**Kafka** - это высокопроизводительный брокер, используется для обработки больших объёмов данных, сотен тысяч сообщений в секунду, которые читаются тысячами подписчиков. **Kafka** легко масштабируемая система, обладающая повышенной отказоустойчивостью, что очень важно в крупных проектах, в банках, телекоммуникационных компаниях и социальных сетях. В Kafka используется подход pull, когда консьюмеры сами отправляют запросы в брокер раз в "n" миллисекунд для получения новой порции сообщений. Такой подход позволяет группировать сообщения в пакеты, достигая лучшей пропускной способности. К минусам модели можно отнести потенциальную разбалансированность нагрузки между разными консьюмерами и более высокую задержку обработки данных. В Kafka сообщения после прочтения косньюмерами не удаляются и могут храниться неограниченное время. Благодаря этому одно и то же сообщение может быть обработано сколько угодно раз разными консьюмерами и в разных контекстах. Kafka хранит большие объемы данных с минимальными издержками, поэтому подходит для передачи большого количества сообщений, в дополнение поддерживает пакетное потребление сообщений.

**RabbitMQ** — это универсальный брокер сообщений. Он отлично подходит для интеграции микросервисов, потоковой передачи данных в режиме реального времени или при передаче работы удалённым работникам. В RabbitMQ используется подход push, когда брокер сам активно отправляет сообщения консьюмерам, которые подписаны на очереди. Плюсы: меньше задержка и равномернее нагрузка. Минусы: меньшая гибкость для потребителя и невозможность потребления сообщений пакетами. В RabbitMQ после получения консьюмерами сообщение удаляется из очереди Благодаря этому одно и то же сообщение может быть обработано только одним консьюмером и не хранится дольше необходимого. Очереди RabbitMQ работают быстрее чем в Kafka, но относительно в небольших объёмах.

Пару слов касательно **Redis**, данный продукт чаще используется как кеширующий сервис быстрых данных для ускорения, так как Redis хранит данные в ОЗУ.
