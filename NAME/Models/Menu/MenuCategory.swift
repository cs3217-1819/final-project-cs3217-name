import Foundation
import RealmSwift

class MenuCategory: Object {

    // MARK: - Properties

    @objc dynamic var name = ""

    // MARK: - Relationships
    @objc dynamic var menu: Menu?
    let items = LinkingObjects(fromType: IndividualMenuItem.self, property: "categories")

    // MARK: - Initialisers

    convenience init(name: String, menu: Menu) {
        self.init()
        self.name = name
        self.menu = menu
    }
}
