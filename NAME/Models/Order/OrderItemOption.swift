import Foundation
import RealmSwift

class OrderItemOption: Object {

    @objc dynamic var menuItemOption: MenuItemOption?

    // To store the different types of option values
    @objc dynamic private var _type: Int = -1
    @objc dynamic private var _type_boolean: Bool = false
    @objc dynamic private var _type_multipleChoice: String = ""
    @objc dynamic private var _type_quantity: Int = 0

    // TODO: extract to constants
    private let delimForMultipleChoiceStore = "###multiplechoicestore###"

    var type: MenuItemOptionType {
        get {
            switch _type {
            case 0:
                return MenuItemOptionType.boolean(_type_boolean)
            case 1:
                let choices = _type_multipleChoice.components(separatedBy: delimForMultipleChoiceStore)
                return MenuItemOptionType.multipleChoice(choices)
            case 2:
                return MenuItemOptionType.quantity(_type_quantity)
            default:
                fatalError("Inconsistent internal representation of menu item option type")
            }
        }
        set(newType) {
            switch newType {
            case .boolean(let val):
                _type = 0
                _type_boolean = val
            case .multipleChoice(let choices):
                _type = 1
                _type_multipleChoice = choices.joined(separator: delimForMultipleChoiceStore)
            case .quantity(let amount):
                _type = 2
                _type_quantity = amount
            }
        }
    }

}
