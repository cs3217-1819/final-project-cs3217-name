import Foundation
import RealmSwift

class Menu: Object {

    // MARK: - Properties

    // MARK: - Relationships
    @objc dynamic var stall: Stall?
    let items = LinkingObjects(fromType: IndividualMenuItem.self, property: "menu")
    let categories = LinkingObjects(fromType: MenuCategory.self, property: "menu")

    // MARK: - Initialisers

    convenience init(stall: Stall) {
        self.init()
        self.stall = stall
    }
}
