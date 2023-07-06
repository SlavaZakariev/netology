## 7.6 Что такое DevOps. CI/CD - Вячеслав Закариев

### Задание 1

1. Установите себе **jenkins** по инструкции из лекции или любым другим способом из официальной документации. Использовать Docker в этом задании нежелательно.
2. Установите на машину с **jenkins golang**.
3. Используя свой аккаунт на **GitHub**, сделайте себе форк [репозитория](https://github.com/netology-code/sdvps-materials). В этом же репозитории находится [дополнительный материал для выполнения ДЗ](https://github.com/netology-code/sdvps-materials/blob/main/CICD/8.2-hw.md).
4. Создайте в jenkins Freestyle Project, подключите получившийся репозиторий к нему и произведите запуск тестов и сборку проекта **go test** . и **docker build** ..

В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки.

---

### Решение 1

1. Установка Jenkins.
![jenkins](https://github.com/SlavaZakariev/netology/blob/cd6a6f922401d3e72875c0e102bab8e55ddfc7d8/ci-cd/7.6_DevOps/resources/jenkins_1.1.jpg)

2. Установка Golang.
![go](https://github.com/SlavaZakariev/netology/blob/af822561fdf1446a6ca6928c8af611f5aec23b1b/ci-cd/7.6_DevOps/resources/jenkins_1.2.jpg)

3. Форк репозитория.
![fork](https://github.com/SlavaZakariev/netology/blob/af822561fdf1446a6ca6928c8af611f5aec23b1b/ci-cd/7.6_DevOps/resources/jenkins_1.3.jpg)

4. Создан проект в Jenkins.
![project](https://github.com/SlavaZakariev/netology/blob/af822561fdf1446a6ca6928c8af611f5aec23b1b/ci-cd/7.6_DevOps/resources/jenkins_1.4.jpg)

Дополнительные шаги.
![build](https://github.com/SlavaZakariev/netology/blob/af822561fdf1446a6ca6928c8af611f5aec23b1b/ci-cd/7.6_DevOps/resources/jenkins_1.5.jpg)

Успешный результат с 14 попытки.
![done](https://github.com/SlavaZakariev/netology/blob/af822561fdf1446a6ca6928c8af611f5aec23b1b/ci-cd/7.6_DevOps/resources/jenkins_1.6.jpg)

---

### Задание 2

1. Создайте новый проект **pipeline**.
2. Перепишите сборку из задания 1 на **declarative** в виде кода.

В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки.

---

### Решение 2

---

### Задание 3

1. Установите на машину **Nexus**.
2. Создайте **raw-hosted** репозиторий.
3. Измените **pipeline** так, чтобы вместо Docker-образа собирался бинарный go-файл. Команду можно скопировать из **Dockerfile**.
4. Загрузите файл в репозиторий с помощью **jenkins**.

В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки.

---

### Решение 3

