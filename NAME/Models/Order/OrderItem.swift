import Foundation
import RealmSwift

protocol OrderItemProtocol {
    var name: String { get }
    var originalPrice: Int { get }
    var discounts: [Discount] { get }
}

class OrderItem: Object, OrderItemProtocol {

    enum DiningOption: Int, CaseIterable {
        case eatin = 0
        case takeaway
    }

    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var quantity: Int = 0
    @objc dynamic var comment: String = ""
    @objc private dynamic var _diningOption: Int = 0

    var name: String {
        return menuItem?.name ?? ""
    }

    var originalPrice: Int {
        let additionalAmounts = addons.reduce(0) { total, addon in
            total + addon.originalPrice
        }

        return (menuItem?.price ?? 0 + additionalAmounts) * quantity
    }

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

    // MARK: - Relationships
    @objc dynamic var order: Order?
    @objc dynamic var menuItem: IndividualMenuItem?
    let addons = List<OrderItem>()
    let orderHistories = List<OrderHistory>()
    let options = List<OrderItemOption>()

    var discounts: [Discount] {
        guard let itemDiscounts = menuItem?.discounts else {
            return []
        }
        return Array(itemDiscounts)
    }

    // MARK: - Initialisers
    convenience init(order: Order?,
                     menuItem: IndividualMenuItem,
                     quantity: Int = 1,
                     comment: String = "",
                     diningOption: DiningOption) {
        self.init()

        self.order = order
        self.menuItem = menuItem
        self.quantity = quantity
        self.comment = comment
        self.diningOption = diningOption
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
