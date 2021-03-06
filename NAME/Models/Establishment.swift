import Foundation
import RealmSwift

class Establishment: Object {

    // MARK: - Properties
    @objc dynamic var id: String = UUID().uuidString

    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var location: String?
    @objc dynamic var details: String?

    let stalls = LinkingObjects(fromType: Stall.self, property: "establishment")
    let discounts = List<Discount>()
    let surcharges = List<Surcharge>()

    // MARK: - Initialisers

    convenience init(name: String,
                     imageURL: String? = nil,
                     location: String? = nil,
                     description: String? = nil) {

        self.init()

        self.name = name
        self.imageURL = imageURL
        self.location = location
        self.details = description
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
