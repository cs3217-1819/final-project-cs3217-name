import Foundation
import RealmSwift

class MenuCategory: Object {

    // MARK: - Properties

    @objc dynamic var name = ""
    let items = List<IndividualMenuItem>()

    // MARK: - Initialisers

    convenience init(name: String, menuItems: [IndividualMenuItem] = []) {
        self.init()
        self.name = name
        self.items.append(objectsIn: menuItems)
    }

    // MARK: - Methods

    func addItem(_ item: IndividualMenuItem) {
        items.append(item)
    }
}
