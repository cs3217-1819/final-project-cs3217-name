//
//  ModelHelper.swift
//  NAME
//
//  Created by Julius on 27/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation

enum ModelHelper {
    static func encodeAsJson<T>(_ value: T) -> Data where T: Encodable {
        do {
            return try JSONEncoder().encode(value)
        } catch {
            fatalError("Unable to encode value of type \(String(describing: T.self))")
        }
    }

    static func decodeAsJson<T>(_ type: T.Type, from data: Data) -> T where T: Decodable {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            fatalError("Unable to decode value of type \(String(describing: T.self))")
        }
    }
}
