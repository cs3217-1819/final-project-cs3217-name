class Surcharge: PriceModifier {

    var name: String = ""
    var priceModification: PriceModification = .multiplier(factor: 1.07)

    convenience init(name: String, priceModification: PriceModification) {
        self.init()

        self.name = name
        self.priceModification = priceModification
    }
}
