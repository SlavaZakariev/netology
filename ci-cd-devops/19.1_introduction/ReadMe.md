## 19.1 Жизненный цикл ПО - Вячеслав Закариев

### Подготовка к выполнению

1. Получить бесплатную версию Jira - https://www.atlassian.com/ru/software/jira/work-management/free (скопируйте ссылку в адресную строку). Вы можете воспользоваться любым(в том числе бесплатным vpn сервисом) если сайт у вас недоступен. Кроме того вы можете скачать [docker образ](https://hub.docker.com/r/atlassian/jira-software/#) и запустить на своем хосте self-managed версию jira.
2. Настроить её для своей команды разработки.
3. Создать доски Kanban и Scrum.
4. [Дополнительные инструкции от разработчика Jira](https://support.atlassian.com/jira-cloud-administration/docs/import-and-export-issue-workflows/).

### Основная часть

Необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. \
Задачи типа bug должны проходить жизненный цикл:

1. Open -> On reproduce.
2. On reproduce -> Open, Done reproduce.
3. Done reproduce -> On fix.
4. On fix -> On reproduce, Done fix.
5. Done fix -> On test.
6. On test -> On fix, Done.
7. Done -> Closed, Open.

Остальные задачи должны проходить по упрощённому workflow:

1. Open -> On develop.
2. On develop -> Open, Done develop.
3. Done develop -> On test.
4. On test -> On develop, Done.
5. Done -> Closed, Open.

**Что нужно сделать**

1. Создайте задачу с типом bug, попытайтесь провести его по всему workflow до Done. 
1. Создайте задачу с типом epic, к ней привяжите несколько задач с типом task, проведите их по всему workflow до Done. 
1. При проведении обеих задач по статусам используйте kanban. 
1. Верните задачи в статус Open.
1. Перейдите в Scrum, запланируйте новый спринт, состоящий из задач эпика и одного бага, стартуйте спринт, проведите задачи до состояния Closed. Закройте спринт.
2. Если всё отработалось в рамках ожидания — выгрузите схемы workflow для импорта в XML. Файлы с workflow и скриншоты workflow приложите к решению задания.

---

### Решение №1

Провёл регистрацию 

![reg](https://github.com/SlavaZakariev/netology/blob/3392f6653660bb2106769bd2cf4418c147e6ca0c/ci-cd-devops/19.1_introduction/resources/jira_1.0.jpg)

Создал workflow 1

![wk1](https://github.com/SlavaZakariev/netology/blob/3392f6653660bb2106769bd2cf4418c147e6ca0c/ci-cd-devops/19.1_introduction/resources/jira_1.1.jpg)

Создал workflow 2

![wk2](https://github.com/SlavaZakariev/netology/blob/3392f6653660bb2106769bd2cf4418c147e6ca0c/ci-cd-devops/19.1_introduction/resources/jira_1.2.jpg)

Создал Kanban доску

![kan](https://github.com/SlavaZakariev/netology/blob/3392f6653660bb2106769bd2cf4418c147e6ca0c/ci-cd-devops/19.1_introduction/resources/jira_1.3.jpg)

Создал Scrum доску

![sc](https://github.com/SlavaZakariev/netology/blob/3392f6653660bb2106769bd2cf4418c147e6ca0c/ci-cd-devops/19.1_introduction/resources/jira_1.4.jpg)
