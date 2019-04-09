import Foundation
import RealmSwift

class Surcharge: Object, PriceModifier {
    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    var name: String = ""
    var priceModification: PriceModification = .multiplier(factor: 1)

    convenience init(name: String, priceModification: PriceModification) {
        self.init()

        self.name = name
        self.priceModification = priceModification
    }

    func toAbsolute(fromAmount: Int) -> Int {

        switch(priceModification) {
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
