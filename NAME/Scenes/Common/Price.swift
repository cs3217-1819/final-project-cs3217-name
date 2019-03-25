// Price and price modifiers

enum Price {
    case absolute(amount: Int)
    case multiplier(factor: Double)
}
