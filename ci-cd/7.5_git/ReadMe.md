
## 7.5 Git - Вячеслав Закариев

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

## Решение 1

1. Зарегистрирован аккаукт в GitHub.

![account](https://github.com/SlavaZakariev/netology/blob/c22ce3ca6b7e6f3283bf17a9d019e1457ba34e41/ci-cd/7.5_git/resources/git_1.1.jpg)

2. Создан публиный репозиторий.

![create](https://github.com/SlavaZakariev/netology/blob/c22ce3ca6b7e6f3283bf17a9d019e1457ba34e41/ci-cd/7.5_git/resources/git_1.2.jpg)

3. Клонирован репозиторий и выполнен переход в директорию git.

![clone](https://github.com/SlavaZakariev/netology/blob/ac4e45162ec152db07b4591b1cfb6956127f35eb/ci-cd/7.5_git/resources/git_1.3.jpg)

4. Произведена настройка.

![name](https://github.com/SlavaZakariev/netology/blob/ac4e45162ec152db07b4591b1cfb6956127f35eb/ci-cd/7.5_git/resources/git_1.4.jpg)

5. Статус git.

![status](https://github.com/SlavaZakariev/netology/blob/ac4e45162ec152db07b4591b1cfb6956127f35eb/ci-cd/7.5_git/resources/git_1.5.jpg)

6. Переведен файл в состояние staged и внесены изменения в файл ReadMe

![staged](https://github.com/SlavaZakariev/netology/blob/e3b461ffda9498a10d4861e9c1c452b784a6f28a/ci-cd/7.5_git/resources/git_1.6.jpg)

7. Изменения в файле

![diff](https://github.com/SlavaZakariev/netology/blob/e3b461ffda9498a10d4861e9c1c452b784a6f28a/ci-cd/7.5_git/resources/git_1.7.jpg)

8. Выполнен **git push origin main**.

![push](https://github.com/SlavaZakariev/netology/blob/6731b19cdaf56330cad08b66396fc6d8ec0d69c9/ci-cd/7.5_git/resources/git_1.8.jpg)

9. Результат синхронизации с облачным GitHub.

![github](https://github.com/SlavaZakariev/netology/blob/ca306df28edea2291912ccb33269fc9e6a8ad07e/ci-cd/7.5_git/resources/git_1.9.jpg)
---
