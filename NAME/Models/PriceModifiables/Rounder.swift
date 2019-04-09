import Foundation
import RealmSwift

class Rounder: Object {

    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString
    var name: String = ""
    var priceModification: PriceModification = .absolute(amount: 0)
  
    private static let roundingResolution: Int = 50

    static func round(_ amount: Int) -> Int {

        return round(Double(amount))
    }

    static func round(_ amount: Double) -> Int {

        guard amount > 0 else {
            return 0
        }

        let roundedValue = (amount / Double(roundingResolution)).rounded()
        return roundingResolution * Int(roundedValue)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
