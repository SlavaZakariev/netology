## 15.5 Elasticsearch - Вячеслав Закариев

### Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

---

### Решение 1

Написан манифест для **docker-compose**

```yaml
version: "3.8"

services:
  elasticsearch:
    build: .
    container_name: netology_elasticsearch
    ports:
      - 9200:9200
      - 9300:9300
    restart: always
```

Подготовлен **dockerfile**
(СТОИТ БЛОКИРОВКА НА СКАЧИВАНИЕ ПАКЕТОВ ЧЕРЕЗ wget ПРИ СБОРКЕ КОНТЕЙНЕРА, ИЩУ АЛЬТЕРНАТИВНОЕ РЕШЕНИЕ)

```dockerfile
FROM ubuntu:22.04
LABEL author=Zakariev

EXPOSE 9200
EXPOSE 9300

RUN export ES_HOME="/var/lib/elasticsearch" && \
    apt -y install wget && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.11.0-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.11.0-linux-x86_64.tar.gz.sha512 && \
    sha512sum -c elasticsearch-8.11.0-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.11.0-linux-x86_64.tar.gz && \
    rm -f elasticsearch-8.11.0-linux-x86_64.tar.gz* && \
    mv elasticsearch-8.11.0 ${ES_HOME} && \

RUN groupadd elasticsearch  && \
    useradd elasticsearch -g elasticsearch -p elasticsearch

RUN chown elasticsearch:elasticsearch -R ${ES_HOME} && \
    mkdir /var/lib/logs && \
    mkdir /var/lib/data && \
    chown elasticsearch:elasticsearch /var/lib/logs && \
    chown elasticsearch:elasticsearch /var/lib/data && \
    apt -y remove wget && \
    apt clean all

COPY ./config/* /var/lib/elasticsearch/config/

USER elasticsearch

ENV ES_HOME="/var/lib/elasticsearch" \
    ES_PATH_CONF="/var/lib/elasticsearch/config"

WORKDIR ${ES_HOME}

CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]
```

Подготовлен файл конфигурации для **elasticsearch**

```yaml
discovery.type: single-node # Состав сервиса - одна нода
node.name: netology_test # Наименование ноды
path.data: /var/lib/data # Место хранения данных
path.logs: /var/lib/logs # Место хранения логов
network.host: 0.0.0.0 # Для корректной работы внутри контейнера
xpack.security.enabled: false # Отключение настроек безопасности
xpack.security.transport.ssl.enabled: false # Отключение шифрования по SSL
```

---

### Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

---

### Решение 2

---

### Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Решение 3

--- 
