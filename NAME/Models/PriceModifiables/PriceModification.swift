enum PriceModification {
    case absolute(amount: Int)
    case multiplier(factor: Double)
}

extension PriceModification: Codable {
    private enum CodingKeys: CodingKey {
        case absolute
        case multiplier
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let amount = try? container.decode(Int.self, forKey: .absolute) {
            self = .absolute(amount: amount)
        } else if let factor = try? container.decode(Double.self, forKey: .multiplier) {
            self = .multiplier(factor: factor)
        } else {
            throw ModelError.deserialization
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .absolute(amount: amount):
            try container.encode(amount, forKey: .absolute)
        case let .multiplier(factor: factor):
            try container.encode(factor, forKey: .multiplier)
        }
    }
}
