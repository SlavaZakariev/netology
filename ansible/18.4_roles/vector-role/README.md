## Роль для установки Vector

Роль предназначена для установки и настройки Vector
- Устанавливает Vector
- Создаёт systemd unit для Vector
- Конфигурирует Vector для передачи данных в ClickHouse

### Требования
- ansible
- Должна быть установлена и сконфигурирована роль ClickHouse

## Переменные

**default/main.yml**
- clickhouse_user: netology
- clickhouse_password: netology

**vars/main.yml** \
endpoint: http://{{ hostvars['clickhouse-01'].ansible_host }}:8123
