//
//  OrderItemTableViewCell.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class OrderItemViewCell: UITableViewCell {
    private let quantitylabel = UILabel()
    private let nameLabel = UILabel()
    private let commentLabel = UILabel()

    var viewModel: OrderItemViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            quantitylabel.text = String(viewModel.quantity)
            nameLabel.text = viewModel.name
            commentLabel.text = viewModel.comment
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupQuantitylabel()
        setupNameLabel()
        setupCommentLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupQuantitylabel() {
        addSubview(quantitylabel)

        quantitylabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(KitchenBacklogConstants.orderItemPadding)
            make.width.equalToSuperview().multipliedBy(KitchenBacklogConstants.leftPanelRatio)
        }
        quantitylabel.textColor = .purple
        quantitylabel.textAlignment = .center
    }

    private func setupNameLabel() {
        addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(KitchenBacklogConstants.orderItemPadding)
            make.width.equalToSuperview().multipliedBy(1 - KitchenBacklogConstants.leftPanelRatio)
        }
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
    }

    private func setupCommentLabel() {
        addSubview(commentLabel)

        commentLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(KitchenBacklogConstants.orderItemPadding)
            make.bottom.equalToSuperview().offset(-KitchenBacklogConstants.orderItemPadding)
            make.width.equalToSuperview().multipliedBy(1 - KitchenBacklogConstants.leftPanelRatio)
        }
        commentLabel.textColor = .black
        commentLabel.textAlignment = .left
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}
