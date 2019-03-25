class Surcharge: PriceModifiable {

    var name: String = ""
    var priceModifier: Price = .multiplier(factor: 1.07)

    convenience init(name: String, priceModifier: Price) {
        self.init()

        self.name = name
        self.priceModifier = priceModifier
    }
}
