import Foundation
import RealmSwift

class IndividualMenuItem: Object, MenuDisplayable {

    // MARK: - Properties

    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var isHidden: Bool = false
    @objc dynamic var quantity: Int = 0
    @objc dynamic private var _price: Int = 0

    public private(set) var priceModifier: Price = .absolute(amount: 0)

    let discounts = List<Discount>()

    @objc dynamic var price: Int {
        get {
            if case let Price.absolute(amount) = priceModifier {
                return amount
            } else {
                fatalError("Price of a menu item should be an absolute amount")
            }
        }
        set(newAmount) {
            self.priceModifier = Price.absolute(amount: newAmount)
            self._price = newAmount
        }
    }

    @objc dynamic var stall: Stall?
    let addOns = List<IndividualMenuItem>()
    let options = List<MenuItemOption>()

    // MARK: - Initialisers

    convenience init(name: String,
         imageURL: String? = nil,
         price: Int,
         isHidden: Bool = false,
         quantity: Int = 1,
         stall: Stall,
         addOns: [IndividualMenuItem] = [],
         options: [MenuItemOption] = []) {

        self.init()

        self.name = name
        self.imageURL = imageURL
        self.price = price
        self.isHidden = isHidden
        self.quantity = quantity

        self.stall = stall

        self.addOns.append(objectsIn: addOns)
        self.options.append(objectsIn: options)
    }

    // MARK: - Methods

    func addDiscount(name: String, priceModifier: Price, stackable: Bool) {
        let discount = Discount(name: name,
                                priceModifier: priceModifier,
                                stackable: stackable,
                                coverage: .item)
        discounts.append(discount)
    }
}