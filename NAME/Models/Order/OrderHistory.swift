import Foundation
import RealmSwift

class OrderHistory: Object {

    @objc dynamic private var _state: Int = -1
    @objc dynamic var timestamp: Date?

    var state: OrderLifecycle? {
        get {
            return OrderLifecycle(rawValue: _state)
        }
        set(newState) {

            guard let newSt = newState else {
                _state = -1
                return
            }

            _state = newSt.rawValue
        }
    }
}
