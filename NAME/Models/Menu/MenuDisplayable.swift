import RealmSwift

protocol MenuDisplayable: Priceable {
    var name: String { get set }
    var imageURL: String? { get set }
    var isHidden: Bool { get set }
    var quantity: Int { get set }

    var categories: List<MenuCategory> { get }
    var discounts: List<Discount> { get }
}
