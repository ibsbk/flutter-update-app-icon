---
name: flutter-update-app-icon
description: >-
  Обновляет launcher-иконку Flutter-приложения для iOS и Android через
  flutter_launcher_icons: master PNG, adaptive icons, очистка старых ассетов.
  Use when the user invokes /flutter-update-app-icon or asks to change the app
  icon, launcher icon, or AppIcon for a Flutter project.
disable-model-invocation: true
---

# Flutter Update App Icon

Меняет только launcher-иконки iOS/Android. Splash, in-app SVG и web PWA не трогать, пока пользователь явно не попросил.

Документацию пиши на языке запроса пользователя.

## Порядок

```
- [ ] Исходник и версия
- [ ] Master PNG
- [ ] Конфиг flutter_launcher_icons
- [ ] Генерация
- [ ] Очистка и сверка
- [ ] Итог
```

### 1. Исходник и версия

Нужен квадратный файл ≥1024×1024. JPEG под `.png` допустим — дальше конвертировать.

Спроси номер версии, если пользователь сказал «обновить версию». Не назвал — только иконки, `pubspec.yaml` version не менять.

Проверь текущее состояние: есть ли `flutter_launcher_icons` в `pubspec.yaml`, какие файлы в `ios/.../AppIcon.appiconset/` и `android/.../mipmap-*`.

### 2. Master PNG

Сохрани настоящий PNG 1024×1024:

```bash
mkdir -p assets/app_icon
sips -s format png "<source>" --out assets/app_icon/app_icon.png
```

Не клади в `assets/icons/` — там обычно UI. Проверь `file` / `sips -g format`: должен быть PNG, не JPEG.

### 3. Конфиг

Добавь `flutter_launcher_icons` в `dev_dependencies` и блок конфига.

**Android padding обязателен.** Safe zone adaptive icon — центральные ~66%. Без inset логотип режется круглой/squircle маской OEM. Дефолт скилла: `adaptive_icon_foreground_inset: 16` (больше — только если пользователь просит сильнее отодвинуть).

Full-bleed квадрат (узор на весь холст): **не** ставь одну и ту же картинку в background и foreground с inset — получится двойной логотип. Background — цвет с края мастера (или бренд-цвет), foreground — master PNG + inset:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.4

flutter_launcher_icons:
  android: true
  ios: true
  image_path: assets/app_icon/app_icon.png
  adaptive_icon_background: "#A22020"
  adaptive_icon_foreground: assets/app_icon/app_icon.png
  adaptive_icon_foreground_inset: 16
  remove_alpha_ios: true
  min_sdk_android: 21
```

Цвет background возьми с угла master PNG или из уже существующего `ic_launcher_background` / бренд-цвета проекта.

Логотип на прозрачном фоне — background цвет или паттерн, foreground логотип, тот же inset `16`. Отдельные fg/bg файлы — только если пользователь их дал.

### 4. Генерация

```bash
flutter pub get
dart run flutter_launcher_icons
```

### 5. Очистка и сверка

Обязательно пройди [pitfalls.md](references/pitfalls.md):

1. `Contents.json` ссылается на `Icon-App-*` — удали старые нумерованные `20.png`…`1024.png`.
2. Adaptive XML перешёл на `@drawable/...` — удали устаревшие `mipmap-*/ic_launcher*.webp` и неиспользуемый `values/ic_launcher_background.xml`.
3. `ic_launcher_round.xml` должен совпадать с `ic_launcher.xml` (генератор часто оставляет старые `@color` / `@mipmap`).
4. Обнови Play Store 512, если в проекте есть `ic_launcher-playstore.png` / `play_store_512.png` / `playstore-icon.png` / `ic_launcher-web.png`.
5. Есть `android:roundIcon` в манифесте — убедись, что round-ресурс существует (adaptive XML и/или `ic_launcher_round.png`).

### 6. Итог

Кратко: путь master PNG, версия (если меняли), что сгенерировано. На устройстве после установки иконка иногда кэшируется — может понадобиться reinstall.

## Запреты

- Не трогать splash (`launch_background`, splash PNG).
- Не трогать `android/_default_res`, web icons, in-app SVG — без явной просьбы.
- Не оставлять битые ссылки в adaptive XML после смены формата ассетов.

Подробный чеклист — [workflow.md](references/workflow.md).
