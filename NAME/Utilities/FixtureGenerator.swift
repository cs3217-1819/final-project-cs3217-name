/// Generate Realm fixtures to seed data store
///
/// Possible usage of FixtureGenerator:
/// 0) Modify file below (take note of options)
/// 1) Run FixtureGenerator.create()
/// 2) Find path that realm file was saved in
///      - po Realm.Configuration.defaultConfiguration.fileURL if no fileURL was specified
/// 3) Copy path into console, open [path] to view output

import RealmSwift

enum FixtureGenerator {

    static func create(deleteRealmIfMigrationNeeded: Bool = true, append: Bool = false) {

        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: deleteRealmIfMigrationNeeded)
        let realm = try! Realm(configuration: realmConfig)

        let establishments = self.createEstablishments(realm)
        let stalls = self.createStalls(realm)
        let menus = self.createMenus(realm, stalls: stalls)
        let categories = self.createMenuCategories(realm, menus: menus)

        // Create menu items

        let item1a1 = IndividualMenuItem(name: "Wonton Mee", price: 3000)
        let item1a2 = IndividualMenuItem(name: "Kolok Mee", price: 3500)
        let item1b1 = IndividualMenuItem(name: "Wonton Mee", price: 3000)
        let item1b2 = IndividualMenuItem(name: "Kolok Mee", price: 3500)

        let item2a1 = IndividualMenuItem(name: "Item A", price: 3000)
        let item2a2 = IndividualMenuItem(name: "Item B", price: 3500)
        let item2b1 = IndividualMenuItem(name: "Item C", price: 4000)
        let item2b2 = IndividualMenuItem(name: "Item D", price: 4500)
        let item2c1 = IndividualMenuItem(name: "Item E", price: 3000)
        let item2c2 = IndividualMenuItem(name: "Item F", price: 3500)
        let item2d1 = IndividualMenuItem(name: "Item G", price: 4000)
        let item2d2 = IndividualMenuItem(name: "Item H", price: 4500)

        let item3a1 = IndividualMenuItem(name: "Fried Fish Rice", price: 5000)
        let item3a2 = IndividualMenuItem(name: "Fried Chicken Noodles", price: 4800)

        //Connect different entities together

        //Add establishment to stalls
        stalls[0].establishment = establishments[0]
        stalls[1].establishment = establishments[0]
        stalls[2].establishment = establishments[0]

        // Add menu to each store
        for i in 0..<menus.count {
            stalls[i].menu = menus[i]
        }

        // Add food items to each category
        item1a1.categories.append(categories[0])
        item1a2.categories.append(categories[0])
        item1b1.categories.append(categories[1])
        item1b2.categories.append(categories[1])

        item2a1.categories.append(categories[2])
        item2a2.categories.append(categories[2])
        item2b1.categories.append(categories[3])
        item2b2.categories.append(categories[3])
        item2c1.categories.append(categories[4])
        item2c2.categories.append(categories[4])
        item2d1.categories.append(categories[5])
        item2d2.categories.append(categories[5])

        item3a1.categories.append(categories[6])
        item3a2.categories.append(categories[6])

        // Save
        try! realm.write {
            if !append {
                realm.deleteAll()
            }
            establishments.forEach { realm.add($0) }
            stalls.forEach { realm.add($0) }
            menus.forEach { realm.add($0) }
            categories.forEach { realm.add($0) }

            [item1a1, item1a2, item1b1, item1b2].forEach { realm.add($0) }
            [item2a1, item2a2, item2b1, item2b2].forEach { realm.add($0) }
            [item2c1, item2c2, item2d1, item2d2].forEach { realm.add($0) }
            [item3a1, item1a2].forEach { realm.add($0) }
        }

    }

    static func createEstablishments(_ realm: Realm) -> [Establishment] {

        let est1 = Establishment(name: "Tony's Food Paradise")

        return [est1]
    }
    static func createStalls(_ realm: Realm) -> [Stall] {

        let stall1 = Stall(name: "Dijkstra's Wonton Mee",
                           location: "Unit 1",
                           details: "Algorithmic pleasure for your taste buds")
        let stall2 = Stall(name: "Knuth's Carrot Cake",
                           location: "Unit 2",
                           details: "Carrot cake for all")
        let stall3 = Stall(name: "Ada's Fried Noodles",
                           location: "Unit 3",
                           details: "Everything stir fried")

        return [stall1, stall2, stall3]
    }

    static func createMenus(_ realm: Realm, stalls: [Stall]) -> [Menu] {

        let menu1 = Menu(stall: stalls[0])
        let menu2 = Menu(stall: stalls[1])
        let menu3 = Menu(stall: stalls[2])

        return [menu1, menu2, menu3]
    }
    static func createMenuCategories(_ realm: Realm, menus: [Menu]) -> [MenuCategory] {

        let cat1a = MenuCategory(name: "Dry Noodles", menu: menus[0])
        let cat1b = MenuCategory(name: "Wet Noodles", menu: menus[0])

        let cat2a = MenuCategory(name: "Roasted Pork", menu: menus[1])
        let cat2b = MenuCategory(name: "Roasted Chicken", menu: menus[1])
        let cat2c = MenuCategory(name: "Roasted Duck", menu: menus[1])
        let cat2d = MenuCategory(name: "Roasted Beef", menu: menus[1])

        let cat3a = MenuCategory(name: "General", menu: menus[2])

        return [cat1a, cat1b,
                cat2a, cat2b, cat2c, cat2d,
                cat3a]
    }
}
