import Foundation
import RealmSwift

class Discount: Object, PriceModifiable {

    var name = ""
    var priceModifier: Price = .multiplier(factor: 1.2)
    var timeCondition: TimeCondition?

}
