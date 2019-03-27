// Price and price modifiers

enum PriceModifier {
    case absolute(amount: Int)
    case multiplier(factor: Double)
}
