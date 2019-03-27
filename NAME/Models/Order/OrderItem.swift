import Foundation
import RealmSwift

class OrderItem: Object {
    enum DiningOption: Int {
        case eatin = 0
        case takeaway
    }

    // MARK: - Properties
    @objc dynamic var menuItem: IndividualMenuItem?
    @objc dynamic var quantity: Int = 0
    @objc dynamic var comment: String = ""
    @objc private dynamic var _diningOption: Int = 0
    let addons = List<OrderItem>()

    var diningOption: DiningOption {
        get {
            guard let diningOption = DiningOption(rawValue: _diningOption) else {
                fatalError("Inconsistent internal representation of dining option")
            }
            return diningOption
        }
        set {
            _diningOption = newValue.rawValue
        }
    }

    // Relationship
    @objc dynamic var order: Order?

    // MARK: - Initialisers
    convenience init(menuItem: IndividualMenuItem,
                     quantity: Int = 1,
                     comment: String = "") {
        self.init()

        self.menuItem = menuItem
        self.quantity = quantity
        self.comment = comment
    }
}
