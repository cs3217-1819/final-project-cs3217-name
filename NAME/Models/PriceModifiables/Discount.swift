import Foundation
import RealmSwift

class Discount: Object, PriceModifier {

    @objc dynamic var name = ""
    var priceModification: PriceModification = .multiplier(factor: 1)
    @objc dynamic private var discountCoverage: Int = -1
    @objc dynamic var stackable: Bool = false

    @objc dynamic private var timeConditionEncoded = Data()
    private var _timeCondition: TimeCondition?
    var timeCondition: TimeCondition {
        get {
            if let timeCondition = _timeCondition {
                return timeCondition
            }
            let timeCondition = ModelHelper.decodeAsJson(TimeCondition.self, from: timeConditionEncoded)
            _timeCondition = timeCondition
            return timeCondition
        }
        set {
            timeConditionEncoded = ModelHelper.encodeAsJson(newValue)
            _timeCondition = newValue
        }
    }

    convenience init(name: String,
                     priceModification: PriceModification,
                     stackable: Bool,
                     timeCondition: TimeCondition) {

        self.init()

        self.name = name
        self.priceModification = priceModification
        self.stackable = stackable
        self.timeCondition = timeCondition
    }
}
