import Foundation
import RealmSwift

class MenuItemOption: Object, Priceable {

    // MARK: - Properties

    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var price: Int = 0
    @objc dynamic private var optionsEncoded = Data()

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
                     price: Int = 0) {
        self.init()

        self.name = name
        self.imageURL = imageURL
        self.options = options
        self.price = price
    }

}
