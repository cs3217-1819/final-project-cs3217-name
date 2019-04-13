//
//  MenuAddonsQuantityViewDelegate.swift
//  NAME
//
//  Created by Julius on 13/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

// TODO to subclass QuantityView
class MenuAddonsQuantityViewDelegate: MenuAddonsTableViewCellProvider {
    let price: String
    let quantity: Int
    private let section: Int

    weak var delegate: MenuAddonsTableViewCellDelegate?

    init(price: String, quantity: Int, section: Int) {
        self.price = price
        self.quantity = quantity
        self.section = section
    }

    func dequeueReusableCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: MenuAddonsTableViewQuantityCell.reuseIdentifier,
                                                         for: indexPath)
        guard let cell = reusableCell as? MenuAddonsTableViewQuantityCell else {
            return reusableCell
        }
        cell.set(dataSourceDelegate: self)
        return cell
    }
}
