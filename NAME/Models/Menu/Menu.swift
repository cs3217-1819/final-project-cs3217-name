import Foundation
import RealmSwift

class Menu: Object {

    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString

    // MARK: - Relationships
    @objc dynamic var stall: Stall?
    private let menuCategories = LinkingObjects(fromType: MenuCategory.self, property: "menu")

    var categories: [MenuCategory] {
        return Array(menuCategories)
    }

    /// Map of menu item IDs in all categories to menu items themselves
    private var menuItemMap: [String: MenuEditable] {
        let menuItems = categories.flatMap { $0.items }
        let menuItemKeysToItems = menuItems.map { ($0.id, $0) }
        return Dictionary(menuItemKeysToItems) { old, _ in old }
    }

    // MARK: - Initialisers
    convenience init(stall: Stall) {
        self.init()
        self.stall = stall
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    // MARK: - Mutators

    /// Must be called in a write transaction
    func add(menuItemIds: [String], toCategory categoryIndex: Int) {
        let category = categories[categoryIndex]
        // Don't add items if they're already in the category. Not using a Set as we want to preserve order.
        let menuItemMap = self.menuItemMap
        for item in menuItemIds.compactMap({ menuItemMap[$0] }) {
            if !item.categories.contains(category) {
                item.add(category: category)
                // TODO: Remove from Uncategorized category
            }
        }
    }

    /// Must be called in a write transaction
    func remove(menuItemIds: [String], fromCategory categoryIndex: Int) {
        let category = categories[categoryIndex]
        let menuItemMap = self.menuItemMap
        for item in menuItemIds.compactMap({ menuItemMap[$0] }) {
            item.remove(category: category)
            // TODO: Add to Uncategorized category if necessary
        }
    }
}
