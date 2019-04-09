protocol PriceModifier {
    var name: String { get set }
    var priceModification: PriceModification { get set }
    func toAbsolute(fromAmount: Int) -> Int
}
