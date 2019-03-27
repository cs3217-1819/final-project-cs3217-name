import Foundation
import RealmSwift

class Customer: Object {
    @objc dynamic var id: String?
    let order = LinkingObjects(fromType: Order.self, property: "customer")
}
