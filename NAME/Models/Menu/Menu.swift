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

    private var uncategorizedCategory: MenuCategory? {
        return menuCategories.filter("isUncategorized == YES").first
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

    private func getOrCreateUncategorizedCategory() -> MenuCategory {
        if let category = uncategorizedCategory {
            return category
        }

        let category = MenuCategory(name: "Uncategorized", menu: self)
        category.isUncategorized = true
        realm?.add(category, update: true)
        return category
    }

    private func removeUncategorizedCategoryIfEmpty() {
        guard let category = uncategorizedCategory else {
            // No uncategorized category to remove
            return
        }
        if category.items.isEmpty {
            realm?.delete(category)
        }
    }

    /// Must be called in a write transaction
    func add(menuItemIds: [String], toCategory categoryIndex: Int) {
        let category = categories[categoryIndex]
        // Don't add items if they're already in the category. Not using a Set as we want to preserve order.
        let menuItemMap = self.menuItemMap
        let uncategorized = uncategorizedCategory
        for item in menuItemIds.compactMap({ menuItemMap[$0] }) {
            if !item.categories.contains(category) {
                // Remove item from all its categories if it was added to the Uncategorized category
                if category.isUncategorized {
                    item.removeAllCategories()
                }

                item.add(category: category)

                // Remove from Uncategorized category, unless it was just purposely added to Uncategorized
                if !category.isUncategorized, let uncategorized = uncategorized {
                    item.remove(category: uncategorized)
                }
            }
        }
        removeUncategorizedCategoryIfEmpty()
    }

    /// Must be called in a write transaction
    func remove(menuItemIds: [String], fromCategory categoryIndex: Int) {
        let category = categories[categoryIndex]
        let menuItemMap = self.menuItemMap
        for item in menuItemIds.compactMap({ menuItemMap[$0] }) {
            item.remove(category: category)

            // Add to Uncategorized category if item is no longer in any category,
            // unless it was just removed from the Uncategorized category.
            if !category.isUncategorized && item.categories.isEmpty {
                item.add(category: getOrCreateUncategorizedCategory())
            }
        }
        removeUncategorizedCategoryIfEmpty()
    }
}
