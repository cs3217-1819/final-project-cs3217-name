import Foundation
import RealmSwift

class Customer: Object {
    @objc dynamic var id: String = UUID().uuidString

    let order = LinkingObjects(fromType: Order.self, property: "customer")

    override static func primaryKey() -> String? {
        return "id"
    }
}
