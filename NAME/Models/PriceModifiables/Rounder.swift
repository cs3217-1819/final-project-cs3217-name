class Rounder: PriceModifiable {

    var name: String = ""
    var priceModifier: PriceModifier = .absolute(amount: 0)

    convenience init(name: String, priceModifier: PriceModifier) {
        self.init()

        self.name = name
        self.priceModifier = priceModifier
    }
}
