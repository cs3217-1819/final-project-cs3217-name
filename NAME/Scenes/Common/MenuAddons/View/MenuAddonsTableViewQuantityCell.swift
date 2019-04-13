//
//  MenuAddonsTableViewQuantityCell.swift
//  NAME
//
//  Created by Julius on 13/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

class MenuAddonsTableViewQuantityCell: UITableViewCell {
    static let reuseIdentifier = String(describing: type(of: self))

    private let quantityView = QuantityView(minimum: 0)
    private let priceLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.textColor = .gray
        return result
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(quantityView)
        addSubview(priceLabel)
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        quantityView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(ConstraintConstants.standardValue)
            make.bottom.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(quantityView.snp.trailing).offset(ConstraintConstants.standardValue)
        }
    }

    func set(dataSourceDelegate: MenuAddonsQuantityViewDelegate) {
        quantityView.delegate = dataSourceDelegate
        quantityView.quantity = dataSourceDelegate.quantity
        priceLabel.text = "(\(dataSourceDelegate.price) each)"
    }
}
