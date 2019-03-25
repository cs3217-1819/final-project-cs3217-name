protocol MenuDisplayable: Priceable {

    var name: String { get set }
    var imageURL: String? { get set }
    var isHidden: Bool { get set }
    var quantity: Int { get set }

    var priceModifier: Price { get }
}
