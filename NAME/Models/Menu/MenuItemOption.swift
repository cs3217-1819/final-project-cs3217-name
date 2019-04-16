import Foundation
import RealmSwift

class MenuItemOption: Object {

    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic private var optionsEncoded = Data()
    @objc dynamic private var defaultValueEncoded = Data()

    private var _defaultValue: OrderItemOptionValue?
    var defaultValue: OrderItemOptionValue {
        get {
            if let defaultValue = _defaultValue {
                return defaultValue
            }
            let defaultValue = ModelHelper.decodeAsJson(OrderItemOptionValue.self, from: defaultValueEncoded)
            _defaultValue = defaultValue
            return defaultValue
        }
        set {
            defaultValueEncoded = ModelHelper.encodeAsJson(newValue)
            _defaultValue = newValue
        }
    }

    private var _options: MenuItemOptionType?
    var options: MenuItemOptionType {
        get {
            if let options = _options {
                return options
            }
            let options = ModelHelper.decodeAsJson(MenuItemOptionType.self, from: optionsEncoded)
            _options = options
            return options
        }
        set {
            optionsEncoded = ModelHelper.encodeAsJson(newValue)
            _options = newValue
        }
    }

    // MARK: - Initialisers

    convenience init(name: String,
                     imageURL: String = "",
                     options: MenuItemOptionType,
                     defaultValue: OrderItemOptionValue) {
        self.init()

        self.name = name
        self.imageURL = imageURL
        self.options = options
        self.defaultValue = defaultValue

        checkRep()
    }

    private func checkRep() {
        switch (options, defaultValue) {
        case (.quantity, .quantity):
            break
        case (.boolean, .boolean):
            break
        case let (.multipleChoice(choices), .multipleChoice(choiceIndex)):
            assert(choiceIndex < choices.count, "multipleChoice's choiceIndex is out of bounds")
        case let (.multipleResponse(choices), .multipleResponse(choiceIndices)):
            assert(choiceIndices.allSatisfy { $0 < choices.count }, "One of multipleResponse's choice is out of bounds")
        default:
            assertionFailure("options and defaultValue does not match")
        }
    }

    override static func primaryKey() -> String? {
        return "id"
    }

}
