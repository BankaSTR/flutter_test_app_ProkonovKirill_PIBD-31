# Лабораторная работа № 5 — мобильный клиент Charity Platform

Flutter-приложение получает благотворительные проекты из Spring Boot backend,
выполненного в рамках дисциплины «Интернет-программирование», и отображает их
список и подробную информацию.

## Клиент-серверное взаимодействие

Приложение обращается к маршруту:

```text
GET /api/1.0/projects?search=<строка поиска>
```

Параметр `search` обрабатывается сервером без учёта регистра. Поиск выполняется
по названию и описанию проекта. Пустой параметр возвращает все проекты.

Клиент разделён на слои:

```text
presentation -> ProjectRepository (interface)
                     |
                     v
              ProjectApiRepository -> ProjectDto -> CardData
```

- `ProjectDto` соответствует JSON-контракту Spring Boot;
- mapper преобразует DTO в доменную модель;
- `ProjectRepository` задаёт интерфейс получения и поиска данных;
- `ProjectApiRepository` реализует интерфейс с помощью Dio.

## Запуск

Сначала запустите backend из проекта
`PIBD-21_Prokonov_K.S._NetworkingProgramming_CharityPlatform`:

```powershell
.\gradlew.bat bootRun
```

После сообщения о запуске сервера выполните в этом проекте:

```powershell
flutter pub get
flutter run
```

Для Android Emulator автоматически используется
`http://10.0.2.2:8080/api/1.0`, для desktop и web —
`http://localhost:8080/api/1.0`.

При запуске на физическом устройстве укажите IP-адрес компьютера в локальной
сети:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8080/api/1.0
```

## Проверка

```powershell
dart run build_runner build
flutter analyze
flutter test
```
