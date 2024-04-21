## Роль для установки Clickhouse

Роль предназначена для установки и настройки ClickHouse (колоночной СУБД) 
- Устанавливает необходимые компоненты
- Создает БД
- Создаёт таблицу логов
- Создаёт пользователя для БД 

### Компоненты
- clickhouse-client
- clickhouse-server
- clickhouse-common-static

### Требования
- ansible
- Доступ к серверу для установки ClickHouse
- Права администратора на сервере

### Переменные 

**default/main.yml**
- clickhouse_user: user
- clickhouse_password: password

**vars/main.yml** \
clickhouse_version: "22.10.4.23" \
clickhouse_packages:
  - clickhouse-client
  - clickhouse-server
  - clickhouse-common-static

clickhouse_config_path: /etc/clickhouse-server/config.xml \
clickhouse_users_path: /etc/clickhouse-server/users.xml
