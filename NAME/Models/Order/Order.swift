import Foundation
import RealmSwift

class Order: Object {

    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var queueNumber: Int = 0

    // MARK: - Relationship
    @objc dynamic var customer: Customer?
    let orderItems = LinkingObjects(fromType: OrderItem.self, property: "order")

    // MARK: - Initialisers

    convenience init(queueNumber: Int, customer: Customer) {
        self.init()

        self.customer = customer
        self.queueNumber = queueNumber
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
