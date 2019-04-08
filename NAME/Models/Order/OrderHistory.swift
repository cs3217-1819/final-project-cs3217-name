import Foundation
import RealmSwift

class OrderHistory: Object {
    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic private var _state: Int = 0
    @objc dynamic var timestamp = Date()

    var state: OrderLifecycle {
        get {
            guard let state = OrderLifecycle(rawValue: _state) else {
                fatalError("Inconsistent internal representation of state")
            }
            return state
        }
        set {
            _state = newValue.rawValue
        }
    }

    convenience init(state: OrderLifecycle, timestamp: Date) {
        self.init()

        self.state = state
        self.timestamp = timestamp
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
