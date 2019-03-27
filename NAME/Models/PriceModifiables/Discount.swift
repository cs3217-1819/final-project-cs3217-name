import Foundation
import RealmSwift

class Discount: Object, PriceModifiable {
    enum Coverage: Int {
        case establishment = 0
        case stall = 1
        case item = 2
    }

    @objc dynamic var name = ""
    var priceModifier: PriceModifier = .multiplier(factor: 1)
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

    var coverage: Coverage {
        get {
            guard let coverage = Coverage(rawValue: discountCoverage) else {
                fatalError("Inconsistent internal representation of coverage")
            }
            return coverage
        }
        set(newCoverage) {
            discountCoverage = newCoverage.rawValue
        }
    }

    convenience init(name: String,
                     priceModifier: PriceModifier,
                     stackable: Bool,
                     coverage: Coverage,
                     timeCondition: TimeCondition) {

        self.init()

        self.name = name
        self.priceModifier = priceModifier
        self.stackable = stackable
        self.coverage = coverage
        self.timeCondition = timeCondition
    }
}
