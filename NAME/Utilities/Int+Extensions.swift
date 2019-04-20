//
//  Int+Extensions.swift
//  NAME
//
//  Created by Julius on 10/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation

extension Int {
    init?(nilOnInvalidValue value: Double) {
        guard value > Double(Int.min) && value < Double(Int.max) else {
            return nil
        }
        self.init(value)
    }

    func formattedAsPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        guard let result = formatter.string(from: (Double(self) / 1_000) as NSNumber) else {
            fatalError("Apple u wot m8")
        }
        return result
    }

    func formattedAsQueueNumberTitle() -> String {
        return OrderConstants.orderNumberPrefix + String(self)
    }
}
