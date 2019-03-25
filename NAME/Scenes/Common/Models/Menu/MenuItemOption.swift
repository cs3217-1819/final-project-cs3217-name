import Foundation
import RealmSwift

class MenuItemOption: Object, Priceable {

    // MARK: - Properties

    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var _type: Int = -1
    @objc dynamic var _price: Int = 0

    // To store the different types of option values
    @objc dynamic var _type_boolean: Bool = false
    @objc dynamic var _type_multipleChoice: String = ""
    @objc dynamic var _type_quantity: Int = 0

    // Deliminator for the storage of multiple choice options as a string
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

    public private(set) var priceModifier: Price = .absolute(amount: 0)

    var price: Int {
        get {
            if case let Price.absolute(amount) = priceModifier {
                return amount
            } else {
                fatalError("Price of a menu item option should be an absolute amount")
            }
        }
        set(newAmount) {
            self.priceModifier = Price.absolute(amount: newAmount)
            self._price = newAmount
        }
    }

    // MARK: - Initialisers

    convenience init(name: String,
                     imageURL: String = "",
                     type: MenuItemOptionType,
                     price: Int = 0) {
        self.init()

        self.name = name
        self.imageURL = imageURL
        self.type = type
        self.price = price
    }

}
