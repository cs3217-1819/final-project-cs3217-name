//
//  OrderHeaderView.swift
//  NAME
//
//  Created by Caryn Heng on 5/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class OrderHeaderView: UIView {
    private let titleLabel = UILabel()

    var viewModel: OrderViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTitleLabel()
        // TODO: Add timer view
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(KitchenBacklogConstants.headerPadding)
            make.width.equalToSuperview()
        }
        titleLabel.textColor = .purple
    }

}
