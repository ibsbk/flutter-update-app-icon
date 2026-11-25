# flutter-update-app-icon

Скилл Cursor для смены launcher-иконки Flutter-приложения на iOS и Android через `flutter_launcher_icons`.

Агент кладёт master PNG в `assets/app_icon/`, настраивает adaptive с padding (`inset: 16`, background — цвет, не тот же PNG), генерирует размеры и подчищает сиротские ассеты, из-за которых ломается сборка или merge.

## Установка

```bash
git clone https://github.com/ibsbk/flutter-update-app-icon.git ~/projects/flutter-update-app-icon
~/projects/flutter-update-app-icon/scripts/install.sh
```

Скрипт создаёт ссылку `~/.cursor/skills/flutter-update-app-icon` на этот репозиторий. Скилл доступен во всех проектах на этом компьютере.

## Вызов

В чате агента: `/flutter-update-app-icon`.

Дай квадратную картинку (≥1024×1024). При необходимости укажи новый `version` в `pubspec.yaml`. Splash и in-app иконки скилл не трогает.
