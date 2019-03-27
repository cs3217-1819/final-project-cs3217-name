import Foundation

enum MenuItemOptionType: Codable {
    case boolean(Bool)
    case quantity(Int)
    case multipleChoice([String])

    enum CodingKeys: CodingKey {
        case boolean
        case quantity
        case multipleChoice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let boolean = try? container.decode(Bool.self, forKey: .boolean) {
            self = .boolean(boolean)
        } else if let boolean = try? container.decode(Int.self, forKey: .quantity) {
            self = .quantity(boolean)
        } else if let multipleChoice = try? container.decode([String].self, forKey: .multipleChoice) {
            self = .multipleChoice(multipleChoice)
        }
        // TODO: Replace this NSError with a customized one
        throw NSError()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .boolean(let boolean):
            try container.encode(boolean, forKey: .boolean)
        case .quantity(let quantity):
            try container.encode(quantity, forKey: .quantity)
        case .multipleChoice(let choices):
            try container.encode(choices, forKey: .multipleChoice)
        }
    }
}
