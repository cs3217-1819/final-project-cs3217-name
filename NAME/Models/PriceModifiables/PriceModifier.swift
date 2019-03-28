// Price and price modifiers

enum PriceModification {
    case absolute(amount: Int)
    case multiplier(factor: Double)
}
