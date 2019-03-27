protocol Priceable {
    /// The price in 0.1 cents (price / 1000).
    ///
    /// This is to prevent floating point error
    var price: Int { get }
}
