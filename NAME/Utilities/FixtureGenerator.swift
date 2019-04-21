/// Generate Realm fixtures to seed data store
///
/// Possible usage of FixtureGenerator:
/// 0) Modify file below (take note of options)
/// 1) Run FixtureGenerator.create()
/// 2) Find path that realm file was saved in
///      - po Realm.Configuration.defaultConfiguration.fileURL if no fileURL was specified
/// 3) Copy path into console, open [path] to view output

import Foundation

// swiftlint:disable function_body_length

enum FixtureGenerator {

    static func create(append: Bool = false) throws {

        // MARK: Models

        let establishments = self.createEstablishments()
        let stalls = self.createStalls()

        let accounts = self.createAccounts(establishments: establishments, stalls: stalls)

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
            manager.add(objects: accounts, update: false)
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
        let est2 = Establishment(name: "Wai Kay's Food Heaven")

        return [est1, est2]
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

    static func createAccounts(establishments: [Establishment], stalls: [Stall]) -> [Account] {
        assert(establishments.count >= 1)
        assert(stalls.count >= 2)

        let acc1 = Account(username: "est1",
                           password: "strongpw",
                           accessControl: .establishment(establishmentId: establishments[0].id))
        let acc2 = Account(username: "est2",
                           password: "strongpw",
                           accessControl: .establishment(establishmentId: establishments[1].id))

        let acc3 = Account(username: "stall1",
                           password: "strongpw",
                           accessControl: .stallOwner(stallId: stalls[0].id))
        let acc4 = Account(username: "stall2",
                           password: "strongpw",
                           accessControl: .stallOwner(stallId: stalls[1].id))

        let acc5 = Account(username: "kitchen1",
                           password: "strongpw",
                           accessControl: .kitchen(stallId: stalls[0].id))
        let acc6 = Account(username: "kitchen2",
                           password: "strongpw",
                           accessControl: .kitchen(stallId: stalls[1].id))

        return [acc1, acc2, acc3, acc4, acc5, acc6]
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
        let cat2e = MenuCategory(name: "Roasted Cat", menu: menus[1])
        let cat2f = MenuCategory(name: "Roasted Fish", menu: menus[1])
        let cat2g = MenuCategory(name: "Roasted Egg", menu: menus[1])
        let cat2h = MenuCategory(name: "Roasted Shark", menu: menus[1])
        let cat2i = MenuCategory(name: "Roasted Human", menu: menus[1])
        let cat2j = MenuCategory(name: "Roasted Dinasaur", menu: menus[1])
        let cat2k = MenuCategory(name: "Roasted Iguana", menu: menus[1])
        let cat2l = MenuCategory(name: "Roasted Cockroach", menu: menus[1])
        let cat2m = MenuCategory(name: "Roasted Bark", menu: menus[1])
        let cat2n = MenuCategory(name: "Roasted Roast", menu: menus[1])
        let cat2o = MenuCategory(name: "Roasted Bone", menu: menus[1])
        let cat2p = MenuCategory(name: "Roasted Lion", menu: menus[1])
        let cat2q = MenuCategory(name: "Roasted Dog", menu: menus[1])

        let cat3a = MenuCategory(name: "General", menu: menus[2])

        return [cat1a, cat1b,
                cat2a, cat2b, cat2c, cat2d, cat2e, cat2f, cat2g, cat2h, cat2i,
                cat2j, cat2k, cat2l, cat2m, cat2n, cat2o, cat2p, cat2q,
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
                                            ("Gonna", 200), ("Give", 100), ("You", 0), ("Up", 1_000)]),
                                         defaultValue: .multipleChoice(5))

        let itemOption4 = MenuItemOption(name: "NDP Songs",
                                         options: .multipleChoice([
                                            ("Count on Me", 100), ("Five stars", 200), ("Litle Things", 300),
                                            ("Stand up", 400),
                                            ("Will You", 500),
                                            ("Home", 600)]),
                                         defaultValue: .multipleChoice(2))

        let itemOption5 = MenuItemOption(name: "Best 3217 TA",
                                         options: .multipleResponse([
                                            ("Herbert", 500), ("Xien Dong", 500), ("Yunpeng", 500),
                                            ("Yanhao", 500), ("Wai Kay", 5_000)]),
                                         defaultValue: .multipleResponse([0, 4]))

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
        let item2e1 = IndividualMenuItem(name: "Item I", price: 3_000, options: options)
        let item2e2 = IndividualMenuItem(name: "Item J", price: 3_500)
        let item2f1 = IndividualMenuItem(name: "Item K", price: 4_000)
        let item2f2 = IndividualMenuItem(name: "Item L", price: 4_500)
        let item2g1 = IndividualMenuItem(name: "Item M", price: 3_000)
        let item2g2 = IndividualMenuItem(name: "Item N", price: 3_500)
        let item2h1 = IndividualMenuItem(name: "Item O", price: 4_000)
        let item2h2 = IndividualMenuItem(name: "Item P", price: 4_500)
        let item2i1 = IndividualMenuItem(name: "Item Q", price: 3_000, options: options)
        let item2i2 = IndividualMenuItem(name: "Item R", price: 3_500)
        let item2j1 = IndividualMenuItem(name: "Item S", price: 4_000)
        let item2j2 = IndividualMenuItem(name: "Item T", price: 4_500)
        let item2k1 = IndividualMenuItem(name: "Item U", price: 3_000)
        let item2k2 = IndividualMenuItem(name: "Item V", price: 3_500)
        let item2l1 = IndividualMenuItem(name: "Item W", price: 4_000)
        let item2l2 = IndividualMenuItem(name: "Item X", price: 4_500)
        let item2m1 = IndividualMenuItem(name: "Item Y", price: 3_000, options: options)
        let item2m2 = IndividualMenuItem(name: "Item Z", price: 3_500)
        let item2n1 = IndividualMenuItem(name: "Item AA", price: 4_000)
        let item2n2 = IndividualMenuItem(name: "Item AB", price: 4_500)
        let item2o1 = IndividualMenuItem(name: "Item AC", price: 3_000)
        let item2o2 = IndividualMenuItem(name: "Item AD", price: 3_500)
        let item2p1 = IndividualMenuItem(name: "Item AE", price: 4_000)
        let item2p2 = IndividualMenuItem(name: "Item AF", price: 4_500)
        let item2q1 = IndividualMenuItem(name: "Item AG", price: 4_000)
        let item2q2 = IndividualMenuItem(name: "Item AH", price: 4_500)

        let item3a1 = IndividualMenuItem(name: "Fried Fish Rice", price: 5_000)
        let item3a2 = IndividualMenuItem(name: "Fried Chicken Noodles", price: 4_800)

        assert(categories.count >= 7)

        item2a1.addAddOns([item2b1, item2b2, item2d1])

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
        item2e1.categories.append(categories[6])
        item2e2.categories.append(categories[6])
        item2f1.categories.append(categories[7])
        item2f2.categories.append(categories[7])
        item2g1.categories.append(categories[8])
        item2g2.categories.append(categories[8])
        item2h1.categories.append(categories[9])
        item2h2.categories.append(categories[9])
        item2i1.categories.append(categories[10])
        item2i2.categories.append(categories[10])
        item2j1.categories.append(categories[11])
        item2j2.categories.append(categories[11])
        item2k1.categories.append(categories[12])
        item2k2.categories.append(categories[12])
        item2l1.categories.append(categories[13])
        item2l2.categories.append(categories[13])
        item2m1.categories.append(categories[14])
        item2m2.categories.append(categories[14])
        item2n1.categories.append(categories[15])
        item2n2.categories.append(categories[15])
        item2o1.categories.append(categories[16])
        item2o2.categories.append(categories[16])
        item2p1.categories.append(categories[17])
        item2p2.categories.append(categories[17])
        item2q1.categories.append(categories[18])
        item2q2.categories.append(categories[18])

        item3a1.categories.append(categories[19])
        item3a2.categories.append(categories[19])

        return [item1a1, item1a2, item1b1, item1b2,
                item2a1, item2a2, item2b1, item2b2, item2c1, item2c2, item2d1, item2d2,
                item2e1, item2e2, item2f1, item2f2, item2g1, item2g2, item2h1, item2h2,
                item2i1, item2i2, item2j1, item2j2, item2k1, item2k2, item2l1, item2l2,
                item2m1, item2m2, item2n1, item2n2, item2o1, item2o2, item2p1, item2p2,
                item2q1, item2q2,
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

        orderItem6.options.append(OrderItemOption(menuItemOption: menuItemOptions[4],
                                                  value: .multipleResponse([1, 2, 3])))

        orderItem6.options.append(OrderItemOption(menuItemOption: menuItemOptions[4],
                                                  value: .multipleResponse([]))) // Should not be displayed in backlog

        return [orderItem1, orderItem2, orderItem3, orderItem4, orderItem5, orderItem6, orderItem7]
    }
}
