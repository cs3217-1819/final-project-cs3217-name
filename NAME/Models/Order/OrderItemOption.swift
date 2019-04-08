import Foundation
import RealmSwift

class OrderItemOption: Object {
    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var menuItemOption: MenuItemOption?
    @objc dynamic private var valueEncoded = Data()

    private var _value: OrderItemOptionValue?
    var value: OrderItemOptionValue {
        get {
            if let value = _value {
                return value
            }
            let value = ModelHelper.decodeAsJson(OrderItemOptionValue.self, from: valueEncoded)
            _value = value
            return value
        }
        set {
            valueEncoded = ModelHelper.encodeAsJson(newValue)
            _value = newValue
        }
    }

    convenience init(menuItemOption: MenuItemOption, value: OrderItemOptionValue) {
        self.init()

        self.menuItemOption = menuItemOption
        self.value = value
    }

    override static func primaryKey() -> String? {
        return "id"
    }

}
