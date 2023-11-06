## 14.1 «Системы контроля версий» - Вячеслав Закариев

### Цель задания

В результате выполнения задания вы: 
* научитесь подготоваливать новый репозиторий к работе;
* сохранять, перемещать и удалять файлы в системе контроля версий.  


### Чеклист готовности к домашнему заданию
1. Установлена консольная утилита для работы с Git.


### Инструкция к заданию

1. Домашнее задание выполните в GitHub-репозитории. 
2. В личном кабинете отправьте на проверку ссылку на ваш репозиторий с домашним заданием.
3. Любые вопросы по решению задач задавайте в чате учебной группы.


### Дополнительные материалы для выполнения задания

1. [GitHub](https://github.com/).
2. [Инструкция по установке Git](https://git-scm.com/downloads).
3. [Книга про  Git на русском языке](https://git-scm.com/book/ru/v2/) - рекомендуем к обязательному изучению главы 1-7.

------

## Задание 1. Создать и настроить репозиторий для дальнейшей работы на курсе

В рамках курса будем писать скрипты и создавать конфигурации для различных систем, которые необходимо сохранять для будущего использования. 
Сначала создадим и настроим локальный репозиторий, после чего добавим удалённый репозиторий на GitHub.

### Создание репозитория и первого коммита

1. Зарегистрируйте аккаунт на [https://github.com/](https://github.com/). Если предпочитаете другое хранилище для репозитория, можно использовать его.
1. Создайте публичный репозиторий, который будете использовать дальше на протяжении всего курса с названием `devops-netology`. \
   Обязательно поставьте галочку `Initialize this repository with a README`. 
   
    ![Диалог создания репозитория](https://github.com/SlavaZakariev/netology/blob/31bfc3a0030cc85f07e7dda4c9f1afe04c6b060f/git/14.1_git-beginning/resources/github-new-repo-1.jpg)
    
1. Создайте [авторизационный токен](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) для клонирования репозитория.
1. Склонируйте репозиторий, используя протокол HTTPS (`git clone ...`).
 
    ![Клонирование репозитория](https://github.com/SlavaZakariev/netology/blob/31bfc3a0030cc85f07e7dda4c9f1afe04c6b060f/git/14.1_git-beginning/resources/github-clone-repo-https.jpg)
    
1. Перейдите в каталог с клоном репозитория (`cd devops-netology`).
1. Произведите первоначальную настройку Git, указав своё настоящее имя, чтобы нам было проще общаться, и email: \
   (`git config --global user.name` и `git config --global user.email johndoe@example.com`).
1. Выполните команду `git status` и запомните результат.
1. Отредактируйте файл `README.md` любым удобным способом, тем самым переведя файл в состояние `Modified`.
1. Ещё раз выполните `git status` и продолжайте проверять вывод этой команды после каждого следующего шага.
1. Теперь посмотрите изменения в файле `README.md`, выполнив команды `git diff` и `git diff --staged`.
1. Переведите файл в состояние `staged` командой `git add README.md`.
1. И ещё раз выполните команды `git diff` и `git diff --staged`. Потренируйтесь с изменениями и этими командами.
1. Теперь можно сделать коммит `git commit -m 'First commit'`.
1. И ещё раз посмотреть выводы команд `git status`, `git diff` и `git diff --staged`.

### Создание файлов `.gitignore` и второго коммита

1. Создайте файл `.gitignore` (обратите внимание на точку в начале файла), проверьте его статус сразу после создания. 
1. Добавьте файл `.gitignore` в следующий коммит (`git add...`).
1. На одном из следующих блоков вы будете изучать `Terraform`, давайте сразу создадим соотвествующий каталог `terraform` и внутри этого каталога — файл `.gitignore` по примеру: https://github.com/github/gitignore/blob/master/Terraform.gitignore.  
1. В файле `README.md` опишите, какие файлы будут проигнорированы в будущем благодаря добавленному `.gitignore`.
1. Закоммитьте все новые и изменённые файлы. Комментарий к коммиту должен быть `Added gitignore`.

### Эксперимент с удалением и перемещением файлов (третий и четвёртый коммит)

1. Создайте файлы `will_be_deleted.txt` (с текстом `will_be_deleted`) и `will_be_moved.txt` (с текстом `will_be_moved`) и закоммите их с комментарием `Prepare to delete and move`.
1. В случае необходимости обратитесь к [официальной документации](https://git-scm.com/book/ru/v2/Основы-Git-Запись-изменений-в-репозиторий) — здесь подробно описано, как выполнить следующие шаги. 
1. Удалите файл `will_be_deleted.txt` с диска и из репозитория. 
1. Переименуйте (переместите) файл `will_be_moved.txt` на диске и в репозитории, чтобы он стал называться `has_been_moved.txt`.
1. Закоммитьте результат работы с комментарием `Moved and deleted`.

### Проверка изменения

1. В результате предыдущих шагов в репозитории должно быть как минимум пять коммитов (если вы сделали промежуточные):
    * `Initial Commit` — созданный GitHub при инициализации репозитория. 
    * `First commit` — созданный после изменения файла `README.md`.
    * `Added gitignore` — после добавления `.gitignore`.
    * `Prepare to delete and move` — после добавления двух временных файлов.
    * `Moved and deleted` — после удаления и перемещения временных файлов. 
2. Проверьте это, используя комманду `git log`. Подробно о формате вывода этой команды мы поговорим на следующем занятии, но посмотреть, что она отображает, можно уже сейчас.

### Отправка изменений в репозиторий

Выполните команду `git push`, если Git запросит логин и пароль — введите ваши логин и пароль от GitHub. \
В качестве результата отправьте ссылку на репозиторий. 

---

## Решение 1

### Репозиторий на GitHub

1. Создан репозиторий **devops-netology**

![gitnew1](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_1.1.jpg)

![gitnew2](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_1.2.jpg)

2. Создан token

![token](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_1.3.jpg)

3. Склонирован репозиторий

![clone](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_1.4.jpg)

4. Сконфигурирован пользователь и почтовый адрес

![user](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_1.5.jpg)

5. Отредактирован файл REAMDME.md и проверен статус

![status](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_1.6.jpg)

6. Просмотр изменений

![gitdiff](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_1.7.jpg)

7. Первый коммит

![commit1](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_1.8.jpg)

### Файл .gitignore

1. Создан файл .gitignore

![ignore1](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_2.1.jpg)

2. Создан каталог terraform и внутри него ещё файл .gitignore согласно шаблону по [ссылке](https://github.com/github/gitignore/blob/main/Terraform.gitignore)

![ignore2](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_2.2.jpg)

### Публикация репозитория

1. Просмотрен лог репозитория

![log](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_3.1.jpg)

2. Выполнена публикация

![log](https://github.com/SlavaZakariev/netology/blob/65c706e4195a8cbd609ca58dedc8d7603b334d12/git/14.1_git-beginning/resources/git-big_3.2.jpg)

3. [Ссылка на репозиторий](https://github.com/SlavaZakariev/devops-netology/blob/main/README.md)
