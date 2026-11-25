# Workflow

Читай этот файл, если нужны детали шагов. Краткий порядок — в `SKILL.md`.

## Разведка

1. Корень приложения — каталог с `pubspec.yaml`.
2. Найди текущие иконки:
   - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
   - Android: `android/app/src/main/res/mipmap-*`, `drawable-*`, `mipmap-anydpi-v26/`
3. Проверь, был ли уже `flutter_launcher_icons` (имя файлов `Icon-App-*` и WebP mipmaps — типичный след прошлой генерации).

## Master asset

| Требование | Значение |
|------------|----------|
| Путь | `assets/app_icon/app_icon.png` |
| Размер | 1024×1024 |
| Формат | настоящий PNG (не JPEG с расширением `.png`) |
| Alpha для iOS marketing | лучше без alpha → `remove_alpha_ios: true` |

Конвертация на macOS:

```bash
sips -s format png "<source>" --out assets/app_icon/app_icon.png
sips -g pixelWidth -g pixelHeight -g format assets/app_icon/app_icon.png
file assets/app_icon/app_icon.png
```

## Конфиг adaptive

Android всегда с padding: `adaptive_icon_foreground_inset: 16` (safe zone ~66%). Без inset круглая маска обрезает стрелки/кольцо у края.

### Full-bleed квадрат (паттерн на весь холст)

- `image_path` / `adaptive_icon_foreground`: master PNG
- `adaptive_icon_background`: hex с угла картинки или бренд-цвет — **не** тот же PNG при inset > 0
- `adaptive_icon_foreground_inset: 16`

Иначе при одном PNG в bg+fg и inset > 0 на маске виден двойной логотип.

### Логотип на прозрачном фоне

- `adaptive_icon_background`: hex или отдельный фон
- `adaptive_icon_foreground`: логотип
- `adaptive_icon_foreground_inset: 16`

## Генерация

```bash
flutter pub get
dart run flutter_launcher_icons
```

Ожидаемо появятся:

- iOS: `Icon-App-*.png` + обновлённый `Contents.json`
- Android: `drawable-*/ic_launcher_{background,foreground}.png`, `mipmap-*/ic_launcher.png`, adaptive XML
- часто: `android/app/src/main/ic_launcher-playstore.png`

## Версия

Меняй `version:` в `pubspec.yaml` только по запросу. Android/iOS обычно берут её через Flutter (`versionName` / `FLUTTER_BUILD_*`). Устаревший `MARKETING_VERSION` в `project.pbxproj` не трогай, если `Info.plist` уже на `$(FLUTTER_BUILD_NAME)`.

## Проверка

- iOS: `Contents.json` → все `filename` существуют; marketing 1024 на месте.
- Android: оба adaptive XML валидны; нет ссылок на удалённые `@color` / `@mipmap` foreground.
- Сравни визуально новый `Icon-App-1024x1024@1x.png` с master PNG.
