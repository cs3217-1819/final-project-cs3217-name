import Foundation
import RealmSwift

class OrderItem: Object {

    @objc dynamic var menuItem: IndividualMenuItem?
    @objc dynamic var quantity: Int = 0
    @objc dynamic var comment: String = ""

    convenience init(menuItem: IndividualMenuItem,
                     quantity: Int = 1,
                     comment: String = "") {
        self.init(menuItem: menuItem)

        self.quantity = quantity
        self.comment = comment
    }
}
