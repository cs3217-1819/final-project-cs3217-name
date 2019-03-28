class Rounder: PriceModifier {

    var name: String = ""
    var priceModification: PriceModification = .absolute(amount: 0)

    convenience init(name: String, priceModification: PriceModification) {
        self.init()

        self.name = name
        self.priceModification = priceModification
    }
}
