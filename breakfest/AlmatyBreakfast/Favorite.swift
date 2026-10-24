import Foundation

struct Favorite {
    let imageName: String
    let title: String
    let description: String
    let address: String
    let price: String

    static let all: [Favorite] = [
        Favorite(imageName: "Breakfast1", title: "WKND", description: "Шакшука со страчателлой\nБриошь с карамелизированной грушей и сливочным кремом\nНапиток на выбор: американо, капучино или латте", address: "улица Жамбыла, 55/57", price: "3 500 ₸"),
        Favorite(imageName: "Breakfast2", title: "COFFEE HILLS", description: "Английский завтрак\nБерлинер\nКапучино 400 мл", address: "ул. Жунисова, 2/23 к3", price: "3 500 ₸"),
        Favorite(imageName: "Breakfast3", title: "Era Coffee House", description: "Шакшука\nБлины с джемом и сметаной\nНапиток на выбор: американо (0,2 л), капучино (0,2 л) или чай (0,4 л)", address: "пр. Серкебаева, 287, блок Б (ЖК GAGARIN PARK)", price: "3 500 ₸"),
        Favorite(imageName: "Breakfast4", title: "Medovic", description: "Тартин Бенедикт с гуакамоле, малосольным лососем, яйцом пашот и миксом зелени\nБельгийские вафли с карамелью и бананом\nНапиток на выбор: Чай черный / зеленый (300 мл) / Американо (150 мл) / Капучино (200 мл)", address: "Улица Кабанбай батыра, 89", price: "3 500 ₸"),
        Favorite(imageName: "Breakfast5", title: "Arabica Coffee House", description: "Шакшука\nСырники\nНапиток на выбор: Черный чай / Чай с молоком (300 мл) / Капучино / Латте / Американо (200 мл)", address: "Проспект Абылай хана, 113 (угол Богенбай Батыра)", price: "3 500 ₸"),
        Favorite(imageName: "Breakfast6", title: "Arabica City Cafe", description: "Шакшука\nДесерт на выбор: «Сникерс» или «Медовик»\nНапиток на выбор: латте, американо, ташкентский чай или Coca-Cola (0,33 л)", address: "Улица Наурызбай батыра, 127 блок 1", price: "3 500 ₸"),
        Favorite(imageName: "Breakfast7", title: "Театралка", description: "Омлет с овощами\nТворожный пирог\nНапиток на выбор: чай с молоком / зелёный чай / чёрный чай / американо / эспрессо / компот / морс", address: "Проспект Абылай хана, 96", price: "3 500 ₸"),
        Favorite(imageName: "Breakfast8", title: "Rosso", description: "Английский завтрак\nГранола с бананом и карамелью\nНапиток на выбор: Кофе (0.3 л) / Лимонад (0.45 л) / Чай черный или зеленый (0.4 л)", address: "проспект Гагарина, 287/2", price: "3 500 ₸"),
        Favorite(imageName: "Breakfast9", title: "Trdelnik", description: "Омлет с индейкой\nКлассический трдельник с корицей или грецкими орехами\nНапиток на выбор: американо (0,25 л), пакетированный чёрный или зелёный чай (0,3 л)", address: "Улица Желтоксан, 148", price: "3 500 ₸"),
        Favorite(imageName: "Breakfast10", title: "Mildom", description: "Завтрак с лососем и авокадо\nБархатный рулет\nНапиток на выбор: американо или капучино", address: "проспект Достык, 172, Grand Mildom", price: "3 500 ₸")
    ]
}

struct FavoriteRoulette {
    private(set) var currentIndex = 0
    let count: Int

    mutating func next() -> Int {
        guard count > 1 else { return currentIndex }
        // Draw from the other nine indices without retrying.
        let draw = Int.random(in: 0..<(count - 1))
        currentIndex = draw >= currentIndex ? draw + 1 : draw
        return currentIndex
    }
}
