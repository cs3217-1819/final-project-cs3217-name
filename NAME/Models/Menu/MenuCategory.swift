import Foundation
import RealmSwift

class MenuCategory: Object {

    // MARK: - Properties

    @objc dynamic var name = ""

    // MARK: - Relationships
    @objc dynamic var menu: Menu?
    private let individualItems = LinkingObjects(fromType: IndividualMenuItem.self, property: "categories")
    private let setItems = LinkingObjects(fromType: SetMenuItem.self, property: "categories")
    var items: [MenuDisplayable] {
        return Array(individualItems) + Array(setItems)
    }

    // MARK: - Initialisers

    convenience init(name: String, menu: Menu) {
        self.init()
        self.name = name
        self.menu = menu
    }
}
