class Rounder: PriceModifiable {

    var name: String = ""
    var priceModifier: Price = .absolute(amount: 0)

    convenience init(name: String, priceModifier: Price) {
        self.init()

        self.name = name
        self.priceModifier = priceModifier
    }
}
