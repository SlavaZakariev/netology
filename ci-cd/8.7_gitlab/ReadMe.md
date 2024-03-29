## 8.7 GitLab - Вячеслав Закариев

### Задание 1

1. Разверните GitLab локально, используя Vagrantfile и инструкцию, описанные в [этом репозитории](https://github.com/netology-code/sdvps-materials/tree/main/gitlab).
2. Создайте новый проект и пустой репозиторий в нём.
3. Зарегистрируйте gitlab-runner для этого проекта и запустите его в режиме Docker. Раннер можно регистрировать и запускать на той же виртуальной машине, на которой запущен GitLab.

В качестве ответа в репозиторий шаблона с решением добавьте скриншоты с настройками раннера в проекте.

---

### Решение 1

1. Развёрнут GitLab

![gitlab](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.4.jpg)

2. Создан проект

![project](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.1.jpg)

3. Зарегистрирован runner

![runner](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.3.jpg)

Процесс регистрации в docker

![docker](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.2.jpg)

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

![gitlab.local](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.10.jpg)

2. Процесс предварительного добавления локального GitLab и вывод списка.

![remote](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.6.jpg)

3. Статус после создания файла **.gitlab-ci.yml**.

![yml](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.7.jpg)

4. Внесение файла **.gitlab-ci.yml** в локальный GitLab.

![push.yml](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.8.jpg)

5. Содержимое файла **.gitlab-ci.yml**.

![cat.yml](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.9.jpg)

6. Выполнение pipeline **(Пришлось откатиться на 14.0 GitLab версию, иначе постоянно выпадает ошибка)**

![pipeline](https://github.com/SlavaZakariev/netology/blob/7fe69426147e0773ccef5c56ed42d0f37d6a7ad5/ci-cd/8.7_gitlab/resources/gitlab_1.11.jpg)
