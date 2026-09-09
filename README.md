# mbium_mobile_client

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## PostgreSQL: создание пользователя и базы данных

Инструкция по подготовке PostgreSQL для бэкенда проекта (пользователь + база данных).
Выполняется на сервере с PostgreSQL от имени администратора БД.

1. Подключитесь к PostgreSQL под суперпользователем `postgres`:

   ```bash
   sudo -u postgres psql
   ```

2. Создайте пользователя (роль) с паролем:

   ```sql
   CREATE USER mbium_user WITH PASSWORD 'change_me';
   ```

3. Создайте базу данных и назначьте владельцем созданного пользователя:

   ```sql
   CREATE DATABASE mbium_db OWNER mbium_user;
   ```

4. Выдайте пользователю все привилегии на базу данных:

   ```sql
   GRANT ALL PRIVILEGES ON DATABASE mbium_db TO mbium_user;
   ```

5. Выйдите из `psql`:

   ```sql
   \q
   ```

6. Проверьте подключение под новым пользователем:

   ```bash
   psql -h localhost -U mbium_user -d mbium_db
   ```

> Замените `mbium_user`, `mbium_db` и пароль на значения, принятые в вашем окружении
> (dev/stage/prod), и никогда не коммитьте реальные пароли в репозиторий —
> храните их в переменных окружения или секретах CI/CD.
