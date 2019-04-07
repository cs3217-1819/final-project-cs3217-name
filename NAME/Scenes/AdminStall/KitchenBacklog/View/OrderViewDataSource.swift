//
//  OrderViewDataSource.swift
//  NAME
//
//  Created by Caryn Heng on 5/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate
class OrderViewDelegate: NSObject, UITableViewDelegate {
}

// MARK: - UITableViewDataSource
class OrderViewDataSource: NSObject, UITableViewDataSource {
    private let cellViewModels: [OrderItemViewModel]

    init(orderItems: [OrderItemViewModel]) {
        self.cellViewModels = orderItems
        super.init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.orderItemCellIdentifier,
                                                       for: indexPath) as? OrderItemViewCell else {
            assertionFailure("Invalid table view cell.")
            return UITableViewCell()
        }

        let viewModel = cellViewModels[indexPath.row]
        cell.viewModel = viewModel
        cell.backgroundColor = .white
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
