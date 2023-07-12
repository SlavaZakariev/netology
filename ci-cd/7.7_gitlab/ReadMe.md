## 7.7 GitLab - Вячеслав Закариев

### Задание 1

1. Разверните GitLab локально, используя Vagrantfile и инструкцию, описанные в [этом репозитории](https://github.com/netology-code/sdvps-materials/tree/main/gitlab).
2. Создайте новый проект и пустой репозиторий в нём.
3. Зарегистрируйте gitlab-runner для этого проекта и запустите его в режиме Docker. Раннер можно регистрировать и запускать на той же виртуальной машине, на которой запущен GitLab.

В качестве ответа в репозиторий шаблона с решением добавьте скриншоты с настройками раннера в проекте.

---

### Решение 1

1. Развёрнут GitLab

![gitlab](https://github.com/SlavaZakariev/netology/blob/20c21427d6ec7be049cba5400de31b9afb38ab66/ci-cd/7.7_gitlab/resources/gitlab_1.4.jpg)

2. Созднан проект

![project](https://github.com/SlavaZakariev/netology/blob/20c21427d6ec7be049cba5400de31b9afb38ab66/ci-cd/7.7_gitlab/resources/gitlab_1.1.jpg)

3. Зарегистрирован runner

![runner](https://github.com/SlavaZakariev/netology/blob/20c21427d6ec7be049cba5400de31b9afb38ab66/ci-cd/7.7_gitlab/resources/gitlab_1.3.jpg)

Процесс регистрации в docker

![docker](https://github.com/SlavaZakariev/netology/blob/20c21427d6ec7be049cba5400de31b9afb38ab66/ci-cd/7.7_gitlab/resources/gitlab_1.2.jpg)

---

### Задание 2

1. Запушьте [репозиторий](https://github.com/netology-code/sdvps-materials/tree/main/gitlab) на GitLab, изменив origin. Это изучалось на занятии по Git.
2. Создайте .gitlab-ci.yml, описав в нём все необходимые, на ваш взгляд, этапы.

В качестве ответа в шаблон с решением добавьте:

* файл gitlab-ci.yml для своего проекта или вставьте код в соответствующее поле в шаблоне;
* скриншоты с успешно собранными сборками.

---

### Решение 2

1. Внесён проект в GitLab.

![gitlab.local](https://github.com/SlavaZakariev/netology/blob/a625f7a14ca6b5065135ad234e04d80afe8bce40/ci-cd/7.7_gitlab/resources/gitlab_1.10.jpg)

2. Процесс предварительного добавления локального GitLab и вывод списка.

![remote](https://github.com/SlavaZakariev/netology/blob/beb6b0452d97be429c338bcec26f69c39a22a03e/ci-cd/7.7_gitlab/resources/gitlab_1.6.jpg)

3. Статус после создания файла **.gitlab-ci.yml**.

![yml](https://github.com/SlavaZakariev/netology/blob/beb6b0452d97be429c338bcec26f69c39a22a03e/ci-cd/7.7_gitlab/resources/gitlab_1.7.jpg)

4. Внесение файла **.gitlab-ci.yml** в локальный GitLab.

![push.yml](https://github.com/SlavaZakariev/netology/blob/beb6b0452d97be429c338bcec26f69c39a22a03e/ci-cd/7.7_gitlab/resources/gitlab_1.8.jpg)

5. Выполнение pipeline ***(ПРИШЛОСЬ ОТКАТИТЬСЯ НА 14.0 ВЕРСИЮ, ЧТО ВЫПОЛНЕНИЕ ПРОШЛО КОРРЕКТНО, ИНАЧЕ ПОСТОЯЯНО ВЫПАДАЕТ ОШИБКА)***

![pipeline](https://github.com/SlavaZakariev/netology/blob/7a8bd4a6b9b1a8c351b1924bf171deb4030dfe25/ci-cd/7.7_gitlab/resources/gitlab_1.11.jpg)

5. Содержимое файла **.gitlab-ci.yml**.

![cat.yml](https://github.com/SlavaZakariev/netology/blob/eb265a797c3266135025592daf4d44dcf67e98bc/ci-cd/7.7_gitlab/resources/gitlab_1.9.jpg)
