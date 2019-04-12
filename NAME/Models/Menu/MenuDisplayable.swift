import RealmSwift

protocol MenuDisplayable: Priceable {
    var id: String { get }
    var name: String { get set }
    var details: String { get set }
    var imageURL: String? { get set }
    var isHidden: Bool { get set }
    var quantity: Int { get set }

    var categories: List<MenuCategory> { get }
    var discounts: List<Discount> { get }
    var options: List<MenuItemOption> { get }
}
