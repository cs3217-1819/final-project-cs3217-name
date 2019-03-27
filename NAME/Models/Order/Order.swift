import Foundation
import RealmSwift

class Order: Object {

    // MARK: - Properties
    let items = List<OrderItem>()
    let history = List<OrderHistory>()
    @objc dynamic var queueNumber: Int = -1

    // Relationship
    @objc dynamic var customer: Customer?
    let orderItems = LinkingObjects(fromType: OrderItem.self, property: "order")

    // MARK: - Initialisers

    convenience init(queueNumber: Int, customer: Customer) {
        self.init()

        self.customer = customer
        self.queueNumber = queueNumber
    }
}
