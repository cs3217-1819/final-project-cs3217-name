import Foundation
import RealmSwift

class Order: Object {

    // MARK: - Properties

    @objc dynamic var customer: Customer?
    let items = List<OrderItem>()
    let history = List<OrderHistory>()
    @objc dynamic var queueNumber: Int = -1

    // MARK: - Initialisers

    convenience init(queueNumber: Int, customer: Customer) {
        self.init()

        self.customer = customer
        self.queueNumber = queueNumber
    }
}
