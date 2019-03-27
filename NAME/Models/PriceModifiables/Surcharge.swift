class Surcharge: PriceModifiable {

    var name: String = ""
    var priceModifier: PriceModifier = .multiplier(factor: 1.07)

    convenience init(name: String, priceModifier: PriceModifier) {
        self.init()

        self.name = name
        self.priceModifier = priceModifier
    }
}
