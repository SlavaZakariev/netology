## 17.1 Введение в Terraform» - Вячеслав Закариев

### Чек-лист готовности к домашнему заданию

1. Скачайте и установите **Terraform** версии =1.5.Х (версия 1.6 может вызывать проблемы с Яндекс провайдером)
2. Скачайте на свой ПК этот git-репозиторий. Исходный код для выполнения задания расположен в директории [01/src](https://github.com/netology-code/ter-homeworks/tree/main/01/src)
3. Убедитесь, что в вашей ОС установлен docker.
4. Зарегистрируйте аккаунт на сайте https://hub.docker.com/, выполните команду docker login и введите логин, пароль.

------
### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Репозиторий с ссылкой на зеркало для установки и настройки Terraform: [ссылка](https://github.com/netology-code/devops-materials).
2. Установка docker: [ссылка](https://docs.docker.com/engine/install/ubuntu/). 

**Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!**

---

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
2. Изучите файл **.gitignore**. В каком terraform-файле, согласно .gitignore, допустимо сохранить личную, секретную информацию?
3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.
6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.
8. Уничтожьте созданные ресурсы с помощью **terraform**. Приложите содержимое файла **terraform.tfstate**. 
9. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **обязательно** подкрепите строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )

---

### Ренешение 1

1. Установленная версия Terraform

![ter](https://github.com/SlavaZakariev/netology/blob/f4c7a300892cbcbeace6f6341619750b03f395e2/terraform/17.1_introduction/resources/ter_1.1.jpg)

2. Согласно файлу **.gitignore** в файле `personal.auto.tfvars` допускается хранить секретные данные
3. Включил VPN для инициализации
   
![init](https://github.com/SlavaZakariev/netology/blob/fdc161982d0bc6b510b7d584edce5fe946d78fb6/terraform/17.1_introduction/resources/ter_1.2.jpg)

4. Далее применил команду **terraform apply**, получен результат `"result": "UXvhE7e1m6imPtf4"` в созданном файле **.terraform.lock.hcl**
5. Раскомментировал и запустил выполнение, выдало две ошибки:
   - 24-я строка: Все блоки ресурсов должны иметь 2 метки (тип, название).
   - 29-я строка: Имя должно начинаться с буквы или знака подчеркивания...
   - 31-я строка: Имя random_string_FAKE не совпадает с объявленным в коревом модуле.

![errors](https://github.com/SlavaZakariev/netology/blob/360bcb3b88a29b000bfb3cd8eef98abcab21552b/terraform/17.1_introduction/resources/ter_1.3.jpg)

6. Исправленная часть кода с 24-й строки:
```terraform
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}

```
7. Результат команды **docker ps**

![ps](https://github.com/SlavaZakariev/netology/blob/7def2a9d490bbd69c6e5e393279eb119f6963b3f/terraform/17.1_introduction/resources/ter_1.4.jpg)

8. Команда **terraform apply -auto-approve** уничтожает текущее состояние ресурсов и заменяет их теми, которые были изменены, без предварительного показа плана. Данная команда в продуктивной среде может нанести непоправимый вред из-за человеческого фактора. Специалисты рекомендую применять данный ключ только в тестовых средах.

Результат команды **docker ps** после применения **terraform apply -auto-approve**

![approve](https://github.com/SlavaZakariev/netology/blob/e8dd0a26fa6dd4d78bc43aa62613c49740b2ec51/terraform/17.1_introduction/resources/ter_1.5.jpg)

9. Данные уничтожены командой **terraform destroy**

![destroy](https://github.com/SlavaZakariev/netology/blob/f53f2cea019f8099abbb3c566266b69bbbb0a540/terraform/17.1_introduction/resources/ter_1.6.jpg)

Содержимое файла **terraform.tfstate**

```terraform
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 18,
  "lineage": "74e65535-806b-381f-f235-86eab714e4a2",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
10. Образ не был удалён так как у нас в файле main.tf был прописан параметр `resource keep_locally = true`, в случае, если заменить на `false`, то снимок данного блока ресурса (контейнера) будет удалён при применении команды **terraform destroy**.


---

### Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 2*

1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл ```personal.auto.tfvars``` и гитигнор или иной, безопасный способ передачи токена!
2. Подключитесь к ВМ по ssh и установите стек docker.
3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
4. Используя terraform и  remote docker context, скачайте и запустите на вашей ВМ контейнер ```mysql:8``` на порту ```127.0.0.1:3306```, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(```name  = "example_${random_password.random_string.result}"```  , двойные кавычки и фигурные скобки обязательны!) 
```
    environment:
      - "MYSQL_ROOT_PASSWORD=${...}"
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - "MYSQL_PASSWORD=${...}"
      - MYSQL_ROOT_HOST="%"
```

6. Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды ```env```. Запишите ваш финальный код в репозиторий.
