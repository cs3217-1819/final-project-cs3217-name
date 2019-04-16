import Foundation

enum MenuItemOptionType {
    case boolean(price: Int)
    case quantity(price: Int)
    case multipleChoice([(name: String, price: Int)])
    case multipleResponse([(name: String, price: Int)])
}

extension MenuItemOptionType: Codable {
    private enum CodingKeys: CodingKey {
        case choices
        case prices
        case metatype
    }

    private enum MetaType: Int, Codable {
        case boolean
        case quantity
        case multipleChoice
        case multipleResponse

        init(of type: MenuItemOptionType) {
            switch type {
            case .boolean: self = .boolean
            case .quantity: self = .quantity
            case .multipleChoice: self = .multipleChoice
            case .multipleResponse: self = .multipleResponse
            }
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let metatype = try container.decode(MetaType.self, forKey: .metatype)
        switch metatype {
        case .boolean:
            let price = try container.decode(Int.self, forKey: .prices)
            self = .boolean(price: price)
        case .quantity:
            let price = try container.decode(Int.self, forKey: .prices)
            self = .quantity(price: price)
        case .multipleChoice:
            let choices = try container.decode([String].self, forKey: .choices)
            let prices = try container.decode([Int].self, forKey: .prices)
            let multipleChoice = zip(choices, prices).map { (name: $0.0, price: $0.1) }
            self = .multipleChoice(multipleChoice)
        case .multipleResponse:
            let choices = try container.decode([String].self, forKey: .choices)
            let prices = try container.decode([Int].self, forKey: .prices)
            let multipleResponse = zip(choices, prices).map { (name: $0.0, price: $0.1) }
            self = .multipleResponse(multipleResponse)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(MetaType(of: self), forKey: .metatype)
        switch self {
        case .boolean(let price):
            try container.encode(price, forKey: .prices)
        case .quantity(let price):
            try container.encode(price, forKey: .prices)
        case .multipleChoice(let rawChoices), .multipleResponse(let rawChoices):
            let choices = rawChoices.map { $0.name }
            let prices = rawChoices.map { $0.price }
            try container.encode(choices, forKey: .choices)
            try container.encode(prices, forKey: .prices)
        }
    }
}
