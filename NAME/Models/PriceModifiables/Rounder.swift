import Foundation
import RealmSwift

class Rounder: Object, PriceModifier {
    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    var name: String = ""
    var priceModification: PriceModification = .absolute(amount: 0)

    convenience init(name: String, priceModification: PriceModification) {
        self.init()

        self.name = name
        self.priceModification = priceModification
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
