## 13.2 Защита хоста - Вячеслав Закариев

### Задание 1

1. Установите **eCryptfs**.
2. Добавьте пользователя cryptouser.
3. Зашифруйте домашний каталог пользователя с помощью eCryptfs.

---

### Решение 1

Установлена **eCryptfs**

![ver](https://github.com/SlavaZakariev/netology/blob/4db08df79ce71e6af4807defb4348e5de78b2a23/inf-security/13.2_host-protection/resources/ecrypt_1.1.jpg)

Создание пользовтеля **cryptouser** и уканаие шифрования на домашний каталог созданного пользователя

![user](https://github.com/SlavaZakariev/netology/blob/4db08df79ce71e6af4807defb4348e5de78b2a23/inf-security/13.2_host-protection/resources/ecrypt_1.2.jpg)

Создание файлов и каталогов

![make](https://github.com/SlavaZakariev/netology/blob/4db08df79ce71e6af4807defb4348e5de78b2a23/inf-security/13.2_host-protection/resources/ecrypt_1.3.jpg)

Просмотр зашифрованного каталога **/home/cryptouser** через пользователя **sysadmin**

![sys](https://github.com/SlavaZakariev/netology/blob/4db08df79ce71e6af4807defb4348e5de78b2a23/inf-security/13.2_host-protection/resources/ecrypt_1.4.jpg)

Просмотр зашифрованного каталога **/home/cryptouser** через пользователя **cryptouser**

![crypto](https://github.com/SlavaZakariev/netology/blob/4db08df79ce71e6af4807defb4348e5de78b2a23/inf-security/13.2_host-protection/resources/ecrypt_1.5.jpg)


---

*В качестве ответа  пришлите снимки экрана домашнего каталога пользователя с исходными и зашифрованными данными.*  

### Задание 2

1. Установите поддержку **LUKS**.
2. Создайте небольшой раздел, например, 100 Мб.
3. Зашифруйте созданный раздел с помощью LUKS.

*В качестве ответа пришлите снимки экрана с поэтапным выполнением задания.*

---

### Решение 2

