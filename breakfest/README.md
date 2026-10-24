# Завтрак Алматы — Favorites Roulette

Учебное одностраничное iOS-приложение на Swift/UIKit со Storyboard. Категория: фестивальные завтраки Алматы. Ровно 10 избранных сетов; подборка не является официальным рейтингом ресторанов.

## Запуск

1. Откройте `AlmatyBreakfast.xcodeproj` в Xcode.
2. Выберите схему `AlmatyBreakfast` и iPhone Simulator с iOS 16 или новее.
3. Нажмите Run (⌘R). Если среда iOS отсутствует, установите её через Xcode Settings → Components.
4. 

При запуске показан WKND. Кнопка «Выбрать другой сет» выбирает один из остальных девяти вариантов. Фото, название, состав, цена и адрес обновляются вместе. Повтор подряд исключён. Интернет приложению не нужен.

## Реализация

- `Favorite.swift`: структура Favorite, массив ровно из 10 элементов и логика случайного выбора.
- `Main.storyboard`: UIImageView, UILabel, explain struct FavoriteRoulette {
    private(set) var currentIndex = 0
    let count: Int

    mutating func next() -> Int {
        guard count > 1 else { return currentIndex }
        // Draw from the other nine indices without retrying.
        let draw = Int.random(in: 0..<(count - 1))
        currentIndex = draw >= currentIndex ? draw + 1 : draw
        return currentIndex
    }UIButton, UIScrollView; Auto Layout отключён, constraints отсутствуют.
- `ViewController.swift`: IBOutlet/IBAction, обновление карточки и адаптация frame к размеру экрана. Прокрутка сохраняет доступность длинного состава; aspectFit сохраняет пропорции фото.
- `LaunchScreen.storyboard`: собственный стартовый экран в цветах приложения, без constraints.
- `Assets.xcassets`: 10 локальных фотографий, LaunchMark и непрозрачный RGB AppIcon 1024 × 1024.
- Display Name: «Завтрак Алматы». Force unwrap отсутствует, кроме разрешённых IBOutlet.

## Данные и фотографии

Источник: [официальный сайт BreakFest](https://breakfest.kz/), снимок данных 24 октября 2026 года. На сайте указаны даты 2–25 октября и цена 3500 ₸. Использован первый сет каждого из 10 заведений, один адрес на заведение. Список: WKND, COFFEE HILLS, Era Coffee House, Medovic, Arabica Coffee House, Arabica City Cafe, Театралка, Rosso, Trdelnik, Mildom.

`Sources.json` содержит адреса исходных фотографий и данные карточек. Фотографии принадлежат их правообладателям; приложение не является официальным продуктом фестиваля. Предложения не обновляются автоматически. На сайте встречаются разные варианты названий улиц; для Era использован адрес из подробной карточки сета.

## Проверка и статус сдачи

Проверка Swift-кода и алгоритма выполняется отдельно от Simulator. Проверка случайного выбора:

```sh
swiftc AlmatyBreakfast/Favorite.swift Checks/main.swift -o /tmp/breakfast-check
/tmp/breakfast-check
```

Полная сборка и запуск Simulator в среде подготовки не подтверждены: CoreSimulator недоступен, инструменты Xcode сообщили `iOS 26.2 Platform Not Installed` / `No available simulator runtimes`. Поэтому скриншоты не подменены макетами, и проект ещё не готов к окончательной сдаче.

## Три обязательных скриншота — осталось добавить

После успешного запуска сохраните в папку `Screenshots`:

1. `launch.png` — LaunchScreen (можно снять кадр записи запуска).
2. `main.png` — главный экран с карточкой.
3. `home.png` — Home Screen Simulator с установленной иконкой.

Добавьте в этот README:

```markdown
![Launch screen](Screenshots/launch.png)
![Main screen](Screenshots/main.png)
![Home Screen](Screenshots/home.png)
```

На Simulator проверьте несколько нажатий, отсутствие повторов подряд, обновление всей карточки и прокрутку длинного состава на небольшом iPhone.

## Публикация для сдачи

Создайте отдельный пустой репозиторий в своём GitHub-аккаунте. Из папки этого проекта:

```sh
git remote add origin https://github.com/YOUR_USERNAME/AlmatyBreakfast.git
git push -u origin HEAD
```

Замените YOUR_USERNAME своим логином. После добавления скриншотов сделайте commit и push. Сдаётся ссылка на ваш репозиторий. Удалённый репозиторий при подготовке не создан: адрес и аккаунт не предоставлены.
