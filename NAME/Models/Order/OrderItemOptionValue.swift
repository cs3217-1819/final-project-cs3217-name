//
//  OrderItemOptionValue.swift
//  NAME
//
//  Created by Julius on 27/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation

enum OrderItemOptionValue {
    case boolean(Bool)
    case quantity(Int)
    case multipleChoice([String])
}

extension OrderItemOptionValue: Codable {
    private enum CodingKeys: CodingKey {
        case choices
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let boolean = try? container.decode(Bool.self, forKey: .choices) {
            self = .boolean(boolean)
        } else if let quantity = try? container.decode(Int.self, forKey: .choices) {
            self = .quantity(quantity)
        } else if let multipleChoice = try? container.decode([String].self, forKey: .choices) {
            self = .multipleChoice(multipleChoice)
        } else {
            throw ModelError.deserialization
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .boolean(boolean):
            try container.encode(boolean, forKey: .choices)
        case let .quantity(quantity):
            try container.encode(quantity, forKey: .choices)
        case let .multipleChoice(choices):
            try container.encode(choices, forKey: .choices)
        }
    }
}
