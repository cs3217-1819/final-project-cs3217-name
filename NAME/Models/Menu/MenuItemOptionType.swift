import Foundation

enum MenuItemOptionType {
    case boolean
    case quantity
    case multipleChoice([String])
}

extension MenuItemOptionType: Codable {
    private enum CodingKeys: CodingKey {
        case choices
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if (try? container.decode(Bool.self, forKey: .choices)) != nil {
            self = .boolean
        } else if (try? container.decode(Int.self, forKey: .choices)) != nil {
            self = .quantity
        } else if let multipleChoice = try? container.decode([String].self, forKey: .choices) {
            self = .multipleChoice(multipleChoice)
        } else {
            throw ModelError.deserialization
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .boolean:
            try container.encode(true, forKey: .choices)
        case .quantity:
            try container.encode(0, forKey: .choices)
        case let .multipleChoice(choices):
            try container.encode(choices, forKey: .choices)
        }
    }
}
