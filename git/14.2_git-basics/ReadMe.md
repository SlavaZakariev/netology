## 14.2 «Основы Git» - Вячеслав Закариев

### Цель задания

В результате выполнения задания вы:

* научитесь работать с Git, как с распределённой системой контроля версий; 
* сможете создавать и настраивать репозиторий для работы в GitHub, GitLab и Bitbucket; 
* попрактикуетесь работать с тегами;
* поработаете с Git при помощи визуального редактора.

### Чеклист готовности к домашнему заданию

1. Установлена консольная утилита для работы с Git.
2. Есть возможность зарегистрироваться на GitHub, GitLab.
3. Регистрация на Bitbucket не является обязательной. 


### Инструкция к заданию

1. В личном кабинете отправьте на проверку ссылки на ваши репозитории.
2. Любые вопросы по решению задач задавайте в чате учебной группы.

------

## Задание 1. Знакомимся с GitLab 

Из-за сложности доступа к Bitbucket в работе достаточно использовать два репозитория: GitHub и GitLab.

Иногда при работе с Git-репозиториями надо настроить свой локальный репозиторий так, чтобы можно было отправлять и принимать изменения из нескольких удалённых репозиториев. 
Это может понадобиться при работе над проектом с открытым исходным кодом, если автор проекта не даёт права на запись в основной репозиторий.

Также некоторые распределённые команды используют такой принцип работы, когда каждый разработчик имеет свой репозиторий, а в основной репозиторий пушатся только конечные результаты 
работы над задачами. 

### GitLab

Создадим аккаунт в GitLab, если у вас его ещё нет:

1. GitLab. Для [регистрации](https://gitlab.com/users/sign_up)  можно использовать аккаунт Google, GitHub и другие. 
1. После регистрации или авторизации в GitLab создайте новый проект, нажав на ссылку `Create a projet`. 
Желательно назвать также, как и в GitHub — `devops-netology` и `visibility level`, выбрать `Public`.
1. Галочку `Initialize repository with a README` лучше не ставить, чтобы не пришлось разрешать конфликты.
1. Если вы зарегистрировались при помощи аккаунта в другой системе и не указали пароль, то увидите сообщение:
`You won't be able to pull or push project code via HTTPS until you set a password on your account`. 
Тогда перейдите [по ссылке](https://gitlab.com/profile/password/edit) из этого сообщения и задайте пароль. 
Если вы уже умеете пользоваться SSH-ключами, то воспользуйтесь этой возможностью (подробнее про SSH мы поговорим в следующем учебном блоке).
1. Перейдите на страницу созданного вами репозитория, URL будет примерно такой:
https://gitlab.com/YOUR_LOGIN/devops-netology. Изучите предлагаемые варианты для начала работы в репозитории в секции
`Command line instructions`. 
1. Запомните вывод команды `git remote -v`.
1. Из-за того, что это будет наш дополнительный репозиторий, ни один вариант из перечисленных в инструкции (на странице 
вновь созданного репозитория) нам не подходит. Поэтому добавляем этот репозиторий, как дополнительный `remote`, к созданному
репозиторию в рамках предыдущего домашнего задания:
`git remote add gitlab https://gitlab.com/YOUR_LOGIN/devops-netology.git`.
1. Отправьте изменения в новый удалённый репозиторий `git push -u gitlab main`.
1. Обратите внимание, как изменился результат работы команды `git remote -v`.

#### Как изменить видимость репозитория в  GitLab — сделать его публичным 

* На верхней панели выберите «Меню» -> «Проекты» и найдите свой проект.
* На левой боковой панели выберите «Настройки» -> «Основные».
* Разверните раздел «Видимость» -> «Функции проекта» -> «Разрешения».
* Измените видимость проекта на Public.
* Нажмите «Сохранить изменения».

---

## Решение 1

1. Создан проект [devops-netology](https://gitlab.com/zakariev/devops-netology) в GitLab

![gitlab](https://github.com/SlavaZakariev/netology/blob/a19f7af57bd8628474386160b293cd9c24e053f7/git/14.2_git-basics/resources/gitlab_1.1.jpg)

2. Добавлен репозиторий на сервер Linux, проверен вывод командой `git remote -v`

![gitlab](https://github.com/SlavaZakariev/netology/blob/a19f7af57bd8628474386160b293cd9c24e053f7/git/14.2_git-basics/resources/gitlab_1.2.jpg)

---

## Задание 2. Теги

Представьте ситуацию, когда в коде была обнаружена ошибка — надо вернуться на предыдущую версию кода,
исправить её и выложить исправленный код в продакшн. Мы никуда не будем выкладывать код, но пометим некоторые коммиты тегами и создадим от них ветки. 

1. Создайте легковестный тег `v0.0` на HEAD-коммите и запуште его во все три добавленных на предыдущем этапе `upstream`.
1. Аналогично создайте аннотированный тег `v0.1`.
1. Перейдите на страницу просмотра тегов в GitHab (и в других репозиториях) и посмотрите, чем отличаются созданные теги. 
    * в GitHub — https://github.com/YOUR_ACCOUNT/devops-netology/releases;
    * в GitLab — https://gitlab.com/YOUR_ACCOUNT/devops-netology/-/tags;
    * в Bitbucket — список тегов расположен в выпадающем меню веток на отдельной вкладке. 

---

## Решение 2

1. Создан легковестный тег `v0.0`

![gitlab](https://github.com/SlavaZakariev/netology/blob/549b321d281e1575fc8c7af77eb1a7372aa4160f/git/14.2_git-basics/resources/gitlab_2.1.jpg)

2. Выполнена публикация на GitHub

![gitlab](https://github.com/SlavaZakariev/netology/blob/549b321d281e1575fc8c7af77eb1a7372aa4160f/git/14.2_git-basics/resources/gitlab_2.2.jpg)

3. Выполнена публикация на GitLab

![gitlab](https://github.com/SlavaZakariev/netology/blob/549b321d281e1575fc8c7af77eb1a7372aa4160f/git/14.2_git-basics/resources/gitlab_2.3.jpg)

4. Создан аннотированный тег `v0.1` с комментарием

![gitlab](https://github.com/SlavaZakariev/netology/blob/549b321d281e1575fc8c7af77eb1a7372aa4160f/git/14.2_git-basics/resources/gitlab_2.4.jpg)

5. Выполнена публикация тегов на [GitHub](https://github.com/SlavaZakariev/devops-netology/tags) и [GitLab](https://gitlab.com/zakariev/devops-netology/-/tags)

![gitlab](https://github.com/SlavaZakariev/netology/blob/549b321d281e1575fc8c7af77eb1a7372aa4160f/git/14.2_git-basics/resources/gitlab_2.5.jpg)

---

## Задание 3. Ветки 

Давайте посмотрим, как будет выглядеть история коммитов при создании веток. 

1. Переключитесь обратно на ветку `main`, которая должна быть связана с веткой `main` репозитория на `github`.
1. Посмотрите лог коммитов и найдите хеш `Prepare to delete and move`, который был создан в предыдущем домашнего задания. 
1. Выполните `git checkout` по хешу найденного коммита. 
1. Создайте новую ветку `fix`, базируясь на этом коммите `git switch -c fix`.
1. Отправьте новую ветку в репозиторий на GitHub `git push -u origin fix`.
1. Посмотрите, как визуально выглядит ваша схема коммитов: https://github.com/YOUR_ACCOUNT/devops-netology/network. 
1. Теперь измените содержание файла `README.md`, добавив новую строчку.
1. Отправьте изменения в репозиторий и посмотрите, как изменится схема на странице https://github.com/YOUR_ACCOUNT/devops-netology/network 
и как изменится вывод команды `git log`.

---

## Решение 3

1. Отсортирован хеш в списке логов по названию коммита, выполнен checkout на данный лог

 ![log](https://github.com/SlavaZakariev/netology/blob/62cdf34c370d11f418acebbe649ce5035fb3626a/git/14.2_git-basics/resources/gitlab_3.1.jpg)

 2. Создана новая ветка fix, опубликована на GitHub

![log](https://github.com/SlavaZakariev/netology/blob/62cdf34c370d11f418acebbe649ce5035fb3626a/git/14.2_git-basics/resources/gitlab_3.2.jpg)

3. График после публикации новой ветки Fix

![log](https://github.com/SlavaZakariev/netology/blob/62cdf34c370d11f418acebbe649ce5035fb3626a/git/14.2_git-basics/resources/gitlab_3.3.jpg)

4. Вносим новую строку в файл README.md, выполняем публикацию в GitHub

![log](https://github.com/SlavaZakariev/netology/blob/62cdf34c370d11f418acebbe649ce5035fb3626a/git/14.2_git-basics/resources/gitlab_3.4.jpg)

5. [График](https://github.com/SlavaZakariev/devops-netology/network) после публикации изменений в файл README.md

![log](https://github.com/SlavaZakariev/netology/blob/62cdf34c370d11f418acebbe649ce5035fb3626a/git/14.2_git-basics/resources/gitlab_3.5.jpg)

6. Список логов по одной строке

![log](https://github.com/SlavaZakariev/netology/blob/62cdf34c370d11f418acebbe649ce5035fb3626a/git/14.2_git-basics/resources/gitlab_3.6.jpg)

---

## Задание 4. Упрощаем себе жизнь

Попробуем поработь с Git при помощи визуального редактора. 

1. В используемой IDE PyCharm откройте визуальный редактор работы с Git, находящийся в меню View -> Tool Windows -> Git.
1. Измените какой-нибудь файл, и он сразу появится на вкладке `Local Changes`, отсюда можно выполнить коммит, нажав на кнопку. 
1. Элементы управления для работы с Git будут выглядеть примерно так:

   ![Работа с гитом](https://github.com/SlavaZakariev/netology/blob/27a09619831114dbd44c678a09cd27a28862c09b/git/14.2_git-basics/resources/ide-git-01.jpg)
   
1. Попробуйте выполнить пару коммитов, используя IDE. [По ссылке](https://www.jetbrains.com/help/pycharm/commit-and-push-changes.html) можно найти информацию по визуальному интерфейсу. 

Если вверху экрана выбрать свою операционную систему, можно посмотреть горячие клавиши для работы с Git. Подробней о визуальном интерфейсе мы расскажем на одной из следующих лекций.

*В качестве результата работы по всем заданиям приложите ссылки на ваши репозитории в GitHub, GitLab и Bitbucket*.  
 
 ---

## Решение 4

Ранее пользовался **Visual Studio Code** при работе с Git. Выполнен коммит и с комментарием и публикация.

![VS](https://github.com/SlavaZakariev/netology/blob/7ff022619d32023985ae75cdebd7593d5ab09daf/git/14.2_git-basics/resources/gitlab_4.1.jpg)

Изменения в файл [README.md](https://github.com/SlavaZakariev/devops-netology) сделанные через VSCode.

![VSC-Git](https://github.com/SlavaZakariev/netology/blob/7ff022619d32023985ae75cdebd7593d5ab09daf/git/14.2_git-basics/resources/gitlab_4.2.jpg)
