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
            checkRep()
        }
    }

    convenience init(menuItemOption: MenuItemOption, value: OrderItemOptionValue) {
        self.init()

        self.menuItemOption = menuItemOption
        self.value = value

        checkRep()
    }

    private func checkRep() {
        guard let menuItemOption = menuItemOption else {
            return
        }
        switch (menuItemOption.options, value) {
        case (.quantity, .quantity):
            break
        case (.boolean, .boolean):
            break
        case let (.multipleChoice(choices), .multipleChoice(choiceIndex)):
            assert(choiceIndex < choices.count, "choiceIndex is out of bounds")
        default:
            assertionFailure("options and defaultValue does not match")
        }
    }

    override static func primaryKey() -> String? {
        return "id"
    }

}
