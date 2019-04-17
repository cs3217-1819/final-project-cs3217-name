import Foundation
import RealmSwift

class IndividualMenuItem: Object, MenuEditable {

    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var details: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var isHidden: Bool = false
    @objc dynamic var quantity: Int = 0
    @objc dynamic private var _price: Int = 0

    @objc dynamic var price: Int = 0

    // MARK: - Relationships
    @objc dynamic var menu: Menu?
    let categories = List<MenuCategory>()
    let discounts = List<Discount>()

    let addOns = List<IndividualMenuItem>()
    let options = List<MenuItemOption>()

    // MARK: - Initialisers

    convenience init(name: String,
                     details: String = "Lorem ipsum dolor sit amet", // TODO remove default value
                     imageURL: String? = nil,
                     price: Int,
                     isHidden: Bool = false,
                     quantity: Int = 1,
                     addOns: [IndividualMenuItem] = [],
                     options: [MenuItemOption] = []) {

        self.init()

        self.name = name
        self.details = details
        self.imageURL = imageURL
        self.price = price
        self.isHidden = isHidden
        self.quantity = quantity

        self.addOns.append(objectsIn: addOns)
        self.options.append(objectsIn: options)
    }

    // MARK: - Methods

    func addDiscount(_ discount: Discount) {
        discounts.append(discount)
    }

    func addAddOn(_ addOn: IndividualMenuItem) {
        addOns.append(addOn)
    }

    func addAddOns(_ addOns: [IndividualMenuItem]) {
        self.addOns.append(objectsIn: addOns)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
