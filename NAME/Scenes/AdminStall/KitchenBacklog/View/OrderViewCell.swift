//
//  OrderListCollectionViewCell.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

final class OrderViewCell: UICollectionViewCell {
    var tableViewDelegate: UITableViewDelegate? {
        didSet {
            setupOrderView()
        }
    }

    var tableViewDataSource: UITableViewDataSource? {
        didSet {
            setupOrderView()
        }
    }

    private var orderView: OrderView?

    var viewModel: OrderViewModel? {
        didSet {
            orderView?.viewModel = viewModel
        }
    }

    private func setupOrderView() {
        guard let tableViewDelegate = tableViewDelegate,
            let tableViewDataSource = tableViewDataSource else {
            return
        }

        orderView = OrderView(frame: frame,
                              tableViewDelegate: tableViewDelegate,
                              tableViewDataSource: tableViewDataSource)

        guard let orderView = orderView else {
            assertionFailure("Order view not initialised.")
            return
        }

        addSubview(orderView)

        orderView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}
