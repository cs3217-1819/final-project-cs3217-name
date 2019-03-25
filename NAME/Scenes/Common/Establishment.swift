import Foundation
import RealmSwift

class Establishment: Object {

    // MARK: - Properties

    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var location: String?
    @objc dynamic var details: String?

    let stalls = List<Stall>()

    // MARK: - Initialisers

    convenience init(name: String,
         imageURL: String? = nil,
         location: String? = nil,
         description: String? = nil,
         stalls: [Stall] = []) {

        self.init()

        self.name = name
        self.imageURL = imageURL
        self.location = location
        self.details = description
        self.stalls.append(objectsIn: stalls)
    }
}
