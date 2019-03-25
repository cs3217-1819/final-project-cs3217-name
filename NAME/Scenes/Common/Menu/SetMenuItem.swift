import Foundation
import RealmSwift

class SetMenuItem: Object, MenuDisplayable {

    // MARK: - Properties

    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var isHidden: Bool = false
    @objc dynamic var quantity: Int = 0
    @objc dynamic var _price: Int = 0 // For Realm requirement to save property

    public private(set) var priceModifier: Price = .absolute(amount: 0)

    @objc dynamic var price: Int {
        get {
            if case let Price.absolute(amount) = priceModifier {
                return amount
            } else {
                fatalError("Price of a menu set should be an absolute amount")
            }
        }
        set(newAmount) {
            self.priceModifier = Price.absolute(amount: newAmount)
            self._price = newAmount
        }
    }

    let items = List<IndividualMenuItem>()

    convenience init(name: String,
                     imageURL: String? = nil,
                     price: Int,
                     isHidden: Bool = false,
                     quantity: Int = 1) {

        self.init()

        self.name = name
        self.imageURL = imageURL
        self.price = price
        self.isHidden = isHidden
        self.quantity = quantity
    }
}
