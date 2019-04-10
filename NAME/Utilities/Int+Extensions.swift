//
//  Int+Extensions.swift
//  NAME
//
//  Created by Julius on 10/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation

extension Int {
    func formattedAsPrice() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: (self / 1_000) as NSNumber)
    }
}
