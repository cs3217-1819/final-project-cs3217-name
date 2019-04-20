//
//  String+Extension.swift
//  NAME
//
//  Created by Julius on 18/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation

extension String {
    func priceAsDouble() -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.number(from: self) as? Double
    }
}
