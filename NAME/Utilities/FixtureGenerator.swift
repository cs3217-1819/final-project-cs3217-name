/// Generate Realm fixtures to seed data store
///
/// Possible usage of FixtureGenerator:
/// 0) Modify file below (take note of options)
/// 1) Run FixtureGenerator.create()
/// 2) Find path that realm file was saved in
///      - po Realm.Configuration.defaultConfiguration.fileURL if no fileURL was specified
/// 3) Copy path into console, open [path] to view output

import Foundation

enum FixtureGenerator {

    static func create(append: Bool = false) throws {

        // MARK: Models

        let establishments = self.createEstablishments()
        let stalls = self.createStalls()

        let menus = self.createMenus(stalls: stalls)
        let categories = self.createMenuCategories(menus: menus)
        let menuItemOptions = self.createMenuItemOptions()
        let menuItems = self.createIndividualMenuItems(categories: categories,
                                                       options: menuItemOptions)

        let customers = self.createCustomers()

        let orders = self.createOrders(customers: customers)
        let orderItems = self.createOrderItems(menuItems: menuItems,
                                               orders: orders,
                                               menuItemOptions: menuItemOptions)

        // MARK: Relationships

        //Add establishment to stalls
        stalls[0].establishment = establishments[0]
        stalls[1].establishment = establishments[0]
        stalls[2].establishment = establishments[0]

        // Add menu to each store
        for (stall, menu) in zip(stalls, menus) {
            stall.menu = menu
        }

        // MARK: Save to Realm

        try RealmStorageManager.shared.writeTransaction { manager in
            if !append {
                manager.clearData()
            }

            manager.add(objects: establishments, update: false)
            manager.add(objects: stalls, update: false)
            manager.add(objects: menus, update: false)
            manager.add(objects: categories, update: false)
            manager.add(objects: customers, update: false)
            manager.add(objects: menuItems, update: false)
            manager.add(objects: orders, update: false)
            manager.add(objects: orderItems, update: false)
        }

    }

    static func createEstablishments() -> [Establishment] {

        let est1 = Establishment(name: "Tony's Food Paradise")

        return [est1]
    }
    static func createStalls() -> [Stall] {

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

    static func createMenus(stalls: [Stall]) -> [Menu] {

        let menu1 = Menu(stall: stalls[0])
        let menu2 = Menu(stall: stalls[1])
        let menu3 = Menu(stall: stalls[2])

        return [menu1, menu2, menu3]
    }

    static func createMenuCategories(menus: [Menu]) -> [MenuCategory] {

        assert(menus.count >= 3)

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

    static func createMenuItemOptions() -> [MenuItemOption] {

        let itemOption1 = MenuItemOption(name: "Vegetables",
                                         options: .boolean(price: 500),
                                         defaultValue: .boolean(false))
        let itemOption2 = MenuItemOption(name: "Golden Mushroom",
                                         options: .quantity(price: 50),
                                         defaultValue: .quantity(1))
        let itemOption3 = MenuItemOption(name: "Broth",
                                         options: .multipleChoice([
                                            ("Chicken", 500), ("Seafood", 400), ("Never", 300),
                                            ("Gonna", 200), ("Give", 100), ("You", 0), ("Up", -100)]),
                                         defaultValue: .multipleChoice(5))

        let itemOption4 = MenuItemOption(name: "NDP Songs",
                                         options: .multipleChoice([
                                            ("Count on Me", 100), ("Five stars", 200), ("Litle Things", 300),
                                            ("Stand up", 400),
                                            ("Will You", 500),
                                            ("Home", 600)]),
                                         defaultValue: .multipleChoice(2))

        let itemOption5 = MenuItemOption(name: "Best 3217 TA",
                                         options: .multipleChoice([
                                            ("Herbert", 0), ("Xien Dong", 0), ("Yunpeng", 0),
                                            ("Yanhao", 0), ("Wai Kay", 0)]),
                                         defaultValue: .multipleChoice(4))

        let itemOption6 = MenuItemOption(name: "2019 General Election Ballot",
                                         options: .multipleChoice([("PAP", 1_000_000), ("PPAP", 0)]),
                                         defaultValue: .multipleChoice(0))

        let itemOption7 = MenuItemOption(name: "Best Language",
                                         options: .multipleChoice([
                                            ("Swift", 0), ("Objective-C", 0), ("C", 0),
                                            ("JavaScript", 0), ("Python", 0), ("Ruby", 0)]),
                                         defaultValue: .multipleChoice(5))

        return [itemOption1, itemOption2, itemOption3, itemOption4, itemOption5, itemOption6, itemOption7]
    }

    static func createIndividualMenuItems(categories: [MenuCategory],
                                          options: [MenuItemOption]) -> [IndividualMenuItem] {

        assert(options.count >= 3)

        let item1a1 = IndividualMenuItem(name: "Wonton Mee", price: 3_000, options: [options[0]])
        let item1a2 = IndividualMenuItem(name: "Kolok Mee", price: 3_500, options: [options[1]])
        let item1b1 = IndividualMenuItem(name: "Wonton Mee", price: 3_000, options: [options[2]])
        let item1b2 = IndividualMenuItem(name: "Kolok Mee", price: 3_500, options: [options[2]])

        let item2a1 = IndividualMenuItem(name: "Item A", price: 3_000, options: options)
        let item2a2 = IndividualMenuItem(name: "Item B", price: 3_500)
        let item2b1 = IndividualMenuItem(name: "Item C", price: 4_000)
        let item2b2 = IndividualMenuItem(name: "Item D", price: 4_500)
        let item2c1 = IndividualMenuItem(name: "Item E", price: 3_000)
        let item2c2 = IndividualMenuItem(name: "Item F", price: 3_500)
        let item2d1 = IndividualMenuItem(name: "Item G", price: 4_000)
        let item2d2 = IndividualMenuItem(name: "Item H", price: 4_500)

        let item3a1 = IndividualMenuItem(name: "Fried Fish Rice", price: 5_000)
        let item3a2 = IndividualMenuItem(name: "Fried Chicken Noodles", price: 4_800)

        assert(categories.count >= 7)

        let now = DateInterval(start: Date(timeIntervalSinceNow: 0),
                               end: Date(timeIntervalSinceNow: 10))

        let discount1 = Discount(name: "Special Promo",
                             priceModification: .absolute(amount: 500),
                             stackable: true,
                             timeCondition: .dayRange(now))

        let discount2 = Discount(name: "Item Special",
                             priceModification: .multiplier(factor: 0.05),
                             stackable: false,
                             timeCondition: .dayRange(now))

        item1a1.addDiscount(discount1)
        item1a1.addDiscount(discount2)

        item1a2.addDiscount(discount1)
        item2a1.addDiscount(discount1)
        item2a2.addDiscount(discount1)

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

        return [item1a1, item1a2, item1b1, item1b2,
                item2a1, item2a2, item2b1, item2b2, item2c1, item2c2, item2d1, item2d2,
                item3a1, item3a2]
    }

    static func createCustomers() -> [Customer] {
        let customer1 = Customer()
        let customer2 = Customer()
        let customer3 = Customer()

        return [customer1, customer2, customer3]
    }

    static func createOrders(customers: [Customer]) -> [Order] {

        assert(customers.count >= 3)

        let order1 = Order(queueNumber: 123, customer: customers[0])
        let order2 = Order(queueNumber: 456, customer: customers[1])
        let order3 = Order(queueNumber: 789, customer: customers[2])
        let order4 = Order(queueNumber: 147, customer: customers[0])

        return [order1, order2, order3, order4]
    }

    static func createOrderItems(menuItems: [IndividualMenuItem],
                                 orders: [Order],
                                 menuItemOptions: [MenuItemOption]) -> [OrderItem] {

        assert(menuItems.count >= 13)
        assert(orders.count >= 4)

        let orderItem1 = OrderItem(order: orders[0],
                                   menuItem: menuItems[0],
                                   quantity: 1,
                                   comment: "Cut the noodles please",
                                   diningOption: .eatin)

        let orderItem2 = OrderItem(order: orders[0],
                                   menuItem: menuItems[12], // Fried Fish Rice
                                   quantity: 2,
                                   comment: "",
                                   diningOption: .eatin)

        let orderItem3 = OrderItem(order: orders[0],
                                   menuItem: menuItems[13], // Fried Chicken Noodles
                                   quantity: 1,
                                   comment: "Don't spill my soup please",
                                   diningOption: .takeaway)

        let orderItem4 = OrderItem(order: orders[1],
                                   menuItem: menuItems[0],
                                   quantity: 1,
                                   comment: "Cut the noodles please. No pork no lard. Actually I want halal version.",
                                   diningOption: .eatin)

        let orderItem5 = OrderItem(order: orders[2],
                                   menuItem: menuItems[12],
                                   quantity: 2,
                                   comment: "",
                                   diningOption: .eatin)

        let orderItem6 = OrderItem(order: orders[2],
                                   menuItem: menuItems[13],
                                   quantity: 1,
                                   comment: "Make it spicy level 999. Thanks.",
                                   diningOption: .takeaway)

        let orderItem7 = OrderItem(order: orders[3],
                                   menuItem: menuItems[13],
                                   quantity: 2,
                                   comment: "",
                                   diningOption: .eatin)

        orderItem4.addons.append(orderItem5)
        orderItem4.addons.append(orderItem6)

        orderItem6.options.append(OrderItemOption(menuItemOption: menuItemOptions[0],
                                                  value: .boolean(true)))

        orderItem6.options.append(OrderItemOption(menuItemOption: menuItemOptions[0],
                                                  value: .boolean(false))) // Should not be displayed in backlog

        orderItem6.options.append(OrderItemOption(menuItemOption: menuItemOptions[1],
                                                  value: .quantity(2)))

        orderItem6.options.append(OrderItemOption(menuItemOption: menuItemOptions[1],
                                                  value: .quantity(0))) // Should not be displayed in backlog

        orderItem6.options.append(OrderItemOption(menuItemOption: menuItemOptions[2],
                                                  value: .multipleChoice(1)))

        return [orderItem1, orderItem2, orderItem3, orderItem4, orderItem5, orderItem6, orderItem7]
    }
}
