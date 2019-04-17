import Foundation
import RealmSwift

class MenuCategory: Object {

    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name = ""

    // MARK: - Relationships
    @objc dynamic var menu: Menu?
    private let individualItems = LinkingObjects(fromType: IndividualMenuItem.self, property: "categories")
    private let setItems = LinkingObjects(fromType: SetMenuItem.self, property: "categories")
    var items: [MenuEditable] {
        return Array(individualItems) + Array(setItems)
    }

    // MARK: - Initialisers

    convenience init(name: String, menu: Menu) {
        self.init()
        self.name = name
        self.menu = menu
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
