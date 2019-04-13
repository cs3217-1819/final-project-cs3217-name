//
//  KitchenBacklogCellHeaderView.swift
//  NAME
//
//  Created by Caryn Heng on 5/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class KitchenBacklogCellHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .purple
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()

    func set(title: String) {
        titleLabel.text = title
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func addSubviews() {
        // TODO: Add timer view
        addSubview(titleLabel)
    }

    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(OrderConstants.headerPadding)
        }
    }

}
