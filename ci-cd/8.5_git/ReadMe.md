
## 8.5 Git - Вячеслав Закариев

### Задание 1

1. Зарегистрируйте аккаунт на GitHub.
2. Создайте публичный репозиторий. Обязательно поставьте галочку в поле «Initialize this repository with a README».
3. Склонируйте репозиторий, используя https протокол **git clone ....**
4. Перейдите в каталог с клоном репозитория.
5. Произведите первоначальную настройку Git, указав своё настоящее имя и email: **git config --global user.name** и **git config --global user.email johndoe@example.com**.
6. Выполните команду **git status** и запомните результат.
7. Отредактируйте файл **README.md** любым удобным способом, переведя файл в состояние **Modified**.
8. Ещё раз выполните **git status** и продолжайте проверять вывод этой команды после каждого следующего шага.
9. Посмотрите изменения в файле **README.md**, выполнив команды **git diff** и **git diff --staged**.
10. Переведите файл в состояние staged или, как говорят, добавьте файл в коммит, командой **git add README.md**.
11. Ещё раз выполните команды **git diff** и **git diff --staged**.
12. Теперь можно сделать коммит **git commit -m 'First commit'**.
13. Сделайте **git push origin master**.
14. В качестве ответа добавьте ссылку на этот коммит в ваш md-файл с решением.

---

### Решение 1

1. Зарегистрирован аккаукт в GitHub.

![account](https://github.com/SlavaZakariev/netology/blob/fd9fe38fb4577746ed7b8849f0cf61d426975f10/ci-cd/8.5_git/resources/git_1.1.jpg)

2. Создан публиный репозиторий.

![create](https://github.com/SlavaZakariev/netology/blob/fd9fe38fb4577746ed7b8849f0cf61d426975f10/ci-cd/8.5_git/resources/git_1.2.jpg)

3. Клонирован репозиторий и выполнен переход в директорию git.

![clone](https://github.com/SlavaZakariev/netology/blob/fd9fe38fb4577746ed7b8849f0cf61d426975f10/ci-cd/8.5_git/resources/git_1.3.jpg)

4. Произведена настройка.

![name](https://github.com/SlavaZakariev/netology/blob/fd9fe38fb4577746ed7b8849f0cf61d426975f10/ci-cd/8.5_git/resources/git_1.4.jpg)

5. Статус git.

![status](https://github.com/SlavaZakariev/netology/blob/fd9fe38fb4577746ed7b8849f0cf61d426975f10/ci-cd/8.5_git/resources/git_1.5.jpg)

6. Переведен файл в состояние staged и внесены изменения в файл ReadMe.

![staged](https://github.com/SlavaZakariev/netology/blob/fd9fe38fb4577746ed7b8849f0cf61d426975f10/ci-cd/8.5_git/resources/git_1.6.jpg)

7. Изменения в файле.

![diff](https://github.com/SlavaZakariev/netology/blob/fd9fe38fb4577746ed7b8849f0cf61d426975f10/ci-cd/8.5_git/resources/git_1.7.jpg)

8. Выполнен **git push origin main**.

![push](https://github.com/SlavaZakariev/netology/blob/fd9fe38fb4577746ed7b8849f0cf61d426975f10/ci-cd/8.5_git/resources/git_1.8.jpg)

Результат синхронизации с облачным [GitHub](https://github.com/SlavaZakariev/git-hw/commit/24b2ebe76b8a52ff9afa744b501bf6d34601bbb1).

---

### Задание 2

1. Создайте файл **.gitignore** (обратите внимание на точку в начале файла) и проверьте его статус сразу после создания.
2. Добавьте файл **.gitignore** в следующий коммит **git add**....
3. Напишите правила в этом файле, чтобы игнорировать любые файлы **.pyc**, а также все файлы в директории cache.
4. Сделайте коммит и пуш.

В качестве ответа добавьте ссылку на этот коммит в ваш md-файл с решением.

---

### Решение 2

1. Файл .gitignore.

![gitignore](https://github.com/SlavaZakariev/netology/blob/49b3997ad80db3fb2278a5b42d430799244d2ae9/ci-cd/8.5_git/resources/git_2.1.jpg)

2. Добавление в следующий коммит.

![gitadd](https://github.com/SlavaZakariev/netology/blob/49b3997ad80db3fb2278a5b42d430799244d2ae9/ci-cd/8.5_git/resources/git_2.2.jpg)

3. Внесение исключенний.

![add](https://github.com/SlavaZakariev/netology/blob/49b3997ad80db3fb2278a5b42d430799244d2ae9/ci-cd/8.5_git/resources/git_2.3.jpg)

4. Выполнение коммит и синхронизация с облаком.

![commit](https://github.com/SlavaZakariev/netology/blob/49b3997ad80db3fb2278a5b42d430799244d2ae9/ci-cd/8.5_git/resources/git_2.4.jpg)

Результат синхронизации с облачным [GitHub](https://github.com/SlavaZakariev/git-hw/commit/136b1c6b7868fd19a7dc135bf625ddb0d037d128).

---

### Задание 3

1. Создайте новую ветку dev и переключитесь на неё.
2. Создайте файл test.sh с произвольным содержимым.
3. Сделайте несколько коммитов и пушей, имитируя активную работу над этим файлом.
4. Сделайте мердж этой ветки в основную. Сначала нужно переключиться на неё, а потом вызывать git merge.
5. Сделайте коммит и пуш.

В качестве ответа прикрепите ссылку на граф коммитов в ваш md-файл с решением.

---

### Решение 3

1. Созднана ветка dev, сделано переключение.

![dev](https://github.com/SlavaZakariev/netology/blob/d58a47636462b4736639249f9d8786376a275325/ci-cd/8.5_git/resources/git_3.1.jpg)

2. Создан файл test.sh.

![.sh](https://github.com/SlavaZakariev/netology/blob/d58a47636462b4736639249f9d8786376a275325/ci-cd/8.5_git/resources/git_3.2.jpg)

3. Обновление файла test, коммит и синхронизация с облаком GitHub.

![updates](https://github.com/SlavaZakariev/netology/blob/d58a47636462b4736639249f9d8786376a275325/ci-cd/8.5_git/resources/git_3.3.jpg)

4. Выполнен merge dev с main.

![merge](https://github.com/SlavaZakariev/netology/blob/d58a47636462b4736639249f9d8786376a275325/ci-cd/8.5_git/resources/git_3.4.jpg)

5. Коммит и синхронизация после merge.

![finalcommit](https://github.com/SlavaZakariev/netology/blob/d58a47636462b4736639249f9d8786376a275325/ci-cd/8.5_git/resources/git_3.5.jpg)

Ссылка на график репозитории main и dev на [GitHub](https://github.com/SlavaZakariev/git-hw/network)
