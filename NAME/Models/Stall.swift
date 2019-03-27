import Foundation
import RealmSwift

class Stall: Object {

    // MARK: - Properties

    @objc dynamic var name = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var location: String?
    @objc dynamic var details: String?

    // MARK: - Relationships
    @objc dynamic var menu: Menu?
    @objc dynamic var establishment: Establishment?

    let discounts = List<Discount>()

    // MARK: - Initialisers

    convenience init(name: String,
         imageURL: String? = nil,
         location: String? = nil,
         details: String? = nil,
         menu: Menu? = nil) {

        self.init()

        self.name = name
        self.imageURL = imageURL
        self.location = location
        self.details = details
        self.menu = menu
    }
}
