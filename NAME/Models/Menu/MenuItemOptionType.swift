import Foundation

enum MenuItemOptionType {
    case boolean(price: Int)
    case quantity(price: Int)
    case multipleChoice([(name: String, price: Int)])
}

extension MenuItemOptionType: Codable {
    private enum CodingKeys: CodingKey {
        case choices
        case prices
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if (try? container.decode(Bool.self, forKey: .choices)) != nil,
            let price = try? container.decode(Int.self, forKey: .prices) {
            self = .boolean(price: price)
        } else if (try? container.decode(Int.self, forKey: .choices)) != nil,
            let price = try? container.decode(Int.self, forKey: .prices) {
            self = .quantity(price: price)
        } else if let choices = try? container.decode([String].self, forKey: .choices),
            let prices = try? container.decode([Int].self, forKey: .prices) {
            let multipleChoice = zip(choices, prices).map { name, price in (name: name, price: price) }
            self = .multipleChoice(multipleChoice)
        } else {
            throw ModelError.deserialization
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .boolean(let price):
            try container.encode(true, forKey: .choices)
            try container.encode(price, forKey: .prices)
        case .quantity(let price):
            try container.encode(0, forKey: .choices)
            try container.encode(price, forKey: .prices)
        case .multipleChoice(let multipleChoices):
            let choices = multipleChoices.map { $0.name }
            let prices = multipleChoices.map { $0.price }
            try container.encode(choices, forKey: .choices)
            try container.encode(prices, forKey: .prices)
        }
    }
}
