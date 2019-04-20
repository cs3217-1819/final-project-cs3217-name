//
//  MenuAddonsQuantityViewDelegate.swift
//  NAME
//
//  Created by Julius on 13/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

class MenuAddonsQuantityViewDelegate: QuantityViewDelegate, MenuAddonsTableViewCellProvider {
    let price: String
    private(set) var quantity: Int
    private let section: Int

    weak var delegate: MenuAddonsTableViewCellDelegate?

    private let isEditable: Bool

    init(price: String, quantity: Int, section: Int, isEditable: Bool) {
        self.price = price
        self.quantity = quantity
        self.section = section
        self.isEditable = isEditable
    }

    func dequeueReusableCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell =
            tableView.dequeueReusableCell(withIdentifier: MenuAddonsTableViewQuantityCell.reuseIdentifier,
                                          for: indexPath)
        guard let cell = reusableCell as? MenuAddonsTableViewQuantityCell else {
            return reusableCell
        }
        cell.set(dataSourceDelegate: self)
        return cell
    }

    func valueDidChange(newValue: Int) {
        quantity = newValue
        delegate?.valueDidSelect(section: section, itemOrQuantity: newValue)
    }
}
