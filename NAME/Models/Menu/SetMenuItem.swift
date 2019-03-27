import Foundation
import RealmSwift

class SetMenuItem: Object, MenuDisplayable {
    // MARK: - Properties
    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var isHidden: Bool = false
    @objc dynamic var quantity: Int = 0

    // MARK: - Relationships
    @objc dynamic var menu: Menu?
    let categories = List<MenuCategory>()
    let discounts = List<Discount>()

    var price: Int {
        get { return items.reduce(0) { $0 + $1.price } }
    }

    let items = List<IndividualMenuItem>()

    convenience init(name: String,
                     imageURL: String? = nil,
                     isHidden: Bool = false,
                     quantity: Int = 1) {

        self.init()

        self.name = name
        self.imageURL = imageURL
        self.isHidden = isHidden
        self.quantity = quantity
    }
}
