import Foundation
import RealmSwift

class Menu: Object {

    // MARK: - Properties

    let menuCategories = List<MenuCategory>()
    let items = List<IndividualMenuItem>()

    // MARK: - Initialisers

    convenience init(categories: [MenuCategory] = [], items: [IndividualMenuItem] = []) {
        self.init()
        self.menuCategories.append(objectsIn: categories)
        self.items.append(objectsIn: items)
    }
}
