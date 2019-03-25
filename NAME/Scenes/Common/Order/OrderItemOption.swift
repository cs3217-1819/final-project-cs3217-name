import Foundation
import RealmSwift

class OrderItemOption: Object {

    @objc dynamic var menuItemOption: MenuItemOption?

    // To store the different types of option values
    @objc dynamic var _type: Int = -1
    @objc dynamic var _type_boolean: Bool = false
    @objc dynamic var _type_multipleChoice: String = ""
    @objc dynamic var _type_quantity: Int = 0

    // TODO: extract to constants
    let delimForMultipleChoiceStore = "###multiplechoicestore###"

    var type: MenuItemOptionType {
        get { return self.type }
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
