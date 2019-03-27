import Foundation

enum TimeCondition {
    case dayRange(DateInterval)
}

extension TimeCondition: Codable {
    private enum CodingKeys: CodingKey {
        case dayRange
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let dayRange = try? container.decode(DateInterval.self, forKey: .dayRange) {
            self = .dayRange(dayRange)
        } else {
            throw ModelError.deserialization
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .dayRange(dayRange):
            try container.encode(dayRange, forKey: .dayRange)
        }
    }
}
