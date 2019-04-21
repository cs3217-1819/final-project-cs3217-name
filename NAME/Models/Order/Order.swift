import Foundation
import RealmSwift

protocol OrderProtocol {
    var orderItems: [OrderItemProtocol] { get }
    var establishmentDiscounts: [Discount]? { get }
    var establishmentSurcharges: [Surcharge]? { get }
}

class Order: Object {

    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var queueNumber: Int = 0

    var orderReceivedTimeStamp: Date? {
        return orderItems
            .flatMap { $0.orderHistories.filter { $0.state == .received } }
            .map { $0.timestamp }
            .min()
    }

    var isOrderReady: Bool {
        return readyStateOrderItems.count == orderItems.count
    }

    var isOrderCompleted: Bool {
        return completedStateOrderItems.count == orderItems.count
    }

    /// All Order Items that are currently at recieved state of lifecycle.
    var receivedStateOrderItems: [OrderItem] {
        return orderItems.filter { $0.orderHistories.last?.state == .received }
    }

    /// All Order Items that are currently at ready state of lifecycle.
    var readyStateOrderItems: [OrderItem] {
        return orderItems.filter { $0.orderHistories.last?.state == .ready }
    }

    /// All Order Items that are currently at completed state of lifecycle.
    var completedStateOrderItems: [OrderItem] {
        return orderItems.filter { $0.orderHistories.last?.state == .completed }
    }

    // MARK: - Relationship
    @objc dynamic var customer: Customer?
    let orderItems = LinkingObjects(fromType: OrderItem.self, property: "order")

    var establishmentDiscounts: [Discount]? {
        guard let discounts = establishment?.discounts else {
            return nil
        }
        return Array(discounts)
    }

    var establishmentSurcharges: [Surcharge]? {
        guard let surcharges = establishment?.surcharges else {
            return nil
        }
        return Array(surcharges)
    }

    private var establishment: Establishment? {
        return orderItems.first?.menuItem?.menu?.stall?.establishment
    }

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
