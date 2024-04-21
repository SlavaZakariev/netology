## Роль для установки Lighthouse

Роль предназначена для установки и настройки Lighthouse
- Cкачивает Lighthouse
- Конфигурирует Lighthouse 

### Требования
- ansible
- Установка и настройка Nginx
- Должна быть установлена и сконфигурирована роль ClickHouse

### Переменные

default/main.yml
- lighthouse_user: netology
- lighthouse_password: netology

vars/main.yml
- lighthouse_vcs: https://github.com/VKCOM/lighthouse.git
- lighthouse_dir: /var/lib/lighthouse
- lighthouse_access_log_name: lighthouse_access
