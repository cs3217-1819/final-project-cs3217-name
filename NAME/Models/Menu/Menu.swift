import Foundation
import RealmSwift

class Menu: Object {

    // MARK: - Properties

    // MARK: - Relationships
    @objc dynamic var stall: Stall?
    private let individualMenuItems = LinkingObjects(fromType: IndividualMenuItem.self, property: "menu")
    private let setMenuItems = LinkingObjects(fromType: SetMenuItem.self, property: "menu")
    private let menuCategories = LinkingObjects(fromType: MenuCategory.self, property: "menu")

    var allItems: [MenuDisplayable] {
        get {
            let indivItems = Array(individualMenuItems).map { $0 as MenuDisplayable }
            let menuItems = Array(setMenuItems).map { $0 as MenuDisplayable }
            return indivItems + menuItems
        }
    }

    // MARK: - Initialisers

    convenience init(stall: Stall) {
        self.init()
        self.stall = stall
    }
}
