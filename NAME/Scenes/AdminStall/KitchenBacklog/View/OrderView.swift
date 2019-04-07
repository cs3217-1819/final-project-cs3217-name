//
//  OrderView.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class OrderView: UIView {
    private let orderHeaderView = OrderHeaderView()
    private var orderTableView: UITableView?

    var viewModel: OrderViewModel? {
        didSet {
            orderHeaderView.viewModel = viewModel
        }
    }

    init(frame: CGRect, tableViewDelegate: UITableViewDelegate, tableViewDataSource: UITableViewDataSource) {
        super.init(frame: frame)

        setupHeaderView()
        setupOrderTableView(tableViewDelegate: tableViewDelegate,
                            tableViewDataSource: tableViewDataSource)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHeaderView() {
        addSubview(orderHeaderView)

        orderHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(KitchenBacklogConstants.headerHeight)
        }
        orderHeaderView.backgroundColor = .gray
    }

    private func setupOrderTableView(tableViewDelegate: UITableViewDelegate,
                                     tableViewDataSource: UITableViewDataSource) {
        orderTableView = UITableView(frame: frame, style: .plain)

        guard let orderTableView = orderTableView else {
            assertionFailure("Order item table view not initialised.")
            return
        }

        addSubview(orderTableView)

        orderTableView.delegate = tableViewDelegate
        orderTableView.dataSource = tableViewDataSource

        orderTableView.register(OrderItemViewCell.self,
                                forCellReuseIdentifier: ReuseIdentifiers.orderItemCellIdentifier)

        orderTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(orderHeaderView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
