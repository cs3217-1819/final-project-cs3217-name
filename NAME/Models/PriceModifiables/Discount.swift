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
    @objc dynamic private var discountCoverage: Int = -1
    @objc dynamic var stackable: Bool = false

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
