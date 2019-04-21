import Foundation
import RealmSwift

class Discount: Object, PriceModifier {
    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString

    @objc dynamic var name = ""
    @objc dynamic private var priceModificationEncoded = Data()
    private var _priceModification: PriceModification?
    var priceModification: PriceModification {
        get {
            if let priceModifier = _priceModification {
                return priceModifier
            }
            let priceModification = ModelHelper.decodeAsJson(PriceModification.self,
                                                             from: priceModificationEncoded)
            _priceModification = priceModification
            return priceModification
        }
        set {
            priceModificationEncoded = ModelHelper.encodeAsJson(newValue)
            _priceModification = newValue
        }
    }

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

    // MARK: - Initialisers
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

    func toAbsolute(fromAmount: Int) -> Int {

        switch priceModification {
        case .absolute(amount: let amount):
            return Rounder.round(amount)
        case .multiplier(factor: let factor):
            return Rounder.round(Double(fromAmount) * factor)
        }
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
