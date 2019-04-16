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
    /// The index of the choice
    case multipleChoice(Int)
    case multipleResponse(Set<Int>)
}

extension OrderItemOptionValue: Codable {
    private enum CodingKeys: CodingKey {
        case choice
        case metatype
    }

    private enum MetaType: Int, Codable {
        case boolean
        case quantity
        case multipleChoice
        case multipleResponse

        init(of value: OrderItemOptionValue) {
            switch value {
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
            let boolean = try container.decode(Bool.self, forKey: .choice)
            self = .boolean(boolean)
        case .quantity:
            let quantity = try container.decode(Int.self, forKey: .choice)
            self = .quantity(quantity)
        case .multipleChoice:
            let choice = try container.decode(Int.self, forKey: .choice)
            self = .multipleChoice(choice)
        case .multipleResponse:
            let choices = try container.decode(Set<Int>.self, forKey: .choice)
            self = .multipleResponse(choices)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(MetaType(of: self), forKey: .metatype)
        switch self {
        case let .boolean(boolean):
            try container.encode(boolean, forKey: .choice)
        case let .quantity(quantity):
            try container.encode(quantity, forKey: .choice)
        case let .multipleChoice(choices):
            try container.encode(choices, forKey: .choice)
        case let .multipleResponse(choices):
            try container.encode(choices, forKey: .choice)
        }
    }
}
