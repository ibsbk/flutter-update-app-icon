# Pitfalls

Типичные поломки после `dart run flutter_launcher_icons`.

## 1. Двойной логотип на Android

Симптом: на adaptive-иконке логотип мельче и лежит поверх того же фона.

Причина: `adaptive_icon_foreground_inset` по умолчанию `16%`, а background и foreground — одна и та же full-bleed картинка.

Фикс: `adaptive_icon_foreground_inset: 0` и перегенерация.

## 2. Сиротские iOS PNG

Генератор пишет `Icon-App-*.png` и обновляет `Contents.json`, но старые `20.png`…`1024.png` остаются на диске.

Фикс: удали файлы, на которые никто не ссылается в `Contents.json`. Иначе при следующем merge они снова всплывут.

## 3. `ic_launcher_round.xml` со старыми ссылками

`ic_launcher.xml` обновляется на `@drawable/...`, а `ic_launcher_round.xml` часто остаётся с `@color/ic_launcher_background` и `@mipmap/ic_launcher_foreground`.

Фикс: скопируй содержимое `ic_launcher.xml` в `ic_launcher_round.xml` (или приведи к тем же drawable + inset).

## 4. Битые ресурсы после смены WebP → drawable

Удали:

- `mipmap-*/ic_launcher.webp`
- `mipmap-*/ic_launcher_round.webp`
- `mipmap-*/ic_launcher_foreground.webp`
- `values/ic_launcher_background.xml` — если background теперь `@drawable/ic_launcher_background`

Оставь `mipmap-*/ic_launcher.png` (и round PNG, если нужны для pre-26 / `android:roundIcon`).

## 5. Play Store всё ещё со старой картинкой

Генератор не всегда перезаписывает все 512×512 копии. Обнови вручную с master:

```bash
sips -z 512 512 assets/app_icon/app_icon.png --out android/app/src/main/ic_launcher-playstore.png
```

То же для `res/ic_launcher-web.png`, `res/play_store_512.png`, `res/playstore-icon.png`, если они есть в репо.

## 6. JPEG под маской PNG

`file` показывает `JPEG image data`, а расширение `.png`. iOS/Android и пакет могут вести себя непредсказуемо.

Фикс: `sips -s format png` в настоящий PNG до генерации.

## 7. Кэш лаунчера на устройстве

После установки новая иконка не видна — reinstall приложения или очистка кэша лаунчера. Это не баг ассетов.
