import Foundation
import RealmSwift

class Discount: Object, PriceModifiable {
    enum Coverage: Int {
        case establishment = 0
        case stall = 1
        case item = 2
    }

    @objc dynamic var name = ""
    var priceModifier: Price = .multiplier(factor: 1)
    @objc dynamic private var _discountCoverage: Int = -1
    @objc dynamic var stackable = false

    var coverage: Coverage {
        get {
            guard let dCoverage = Coverage(rawValue: _discountCoverage) else {
                fatalError("Inconsistent internal representation of coverage")
            }
            return dCoverage
        }
        set(newCoverage) {
            _discountCoverage = newCoverage.rawValue
        }
    }

    convenience init(name: String,
                     priceModifier: Price,
                     stackable: Bool,
                     coverage: Coverage) {

        self.init()

        self.name = name
        self.priceModifier = priceModifier
        self.stackable = stackable
        self.coverage = coverage
    }
}
