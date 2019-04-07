import Foundation
import RealmSwift

class Menu: Object {

    // MARK: - Properties

    // MARK: - Relationships
    @objc dynamic var stall: Stall?
    private let menuCategories = LinkingObjects(fromType: MenuCategory.self, property: "menu")

    var categories: [MenuCategory] {
        return Array(menuCategories)
    }

    // MARK: - Initialisers

    convenience init(stall: Stall) {
        self.init()
        self.stall = stall
    }
}
