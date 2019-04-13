//
//  OrderItemTableViewCell.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

protocol OrderItemViewCellDelegate: class {
    func didTapReady(forCell cell: UITableViewCell)
}

class OrderItemViewCell: UITableViewCell {
    private var isItemPrepared = false {
        didSet {
            let arrangedSubviews = isItemPrepared ? [itemStackView] : [itemStackView, readyButton]
            let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.alignment = .center
            stackView.spacing = OrderConstants.orderItemPadding
            contentStackView = stackView
        }
    }

    weak var delegate: OrderItemViewCellDelegate?

    private let quantitylabel: UILabel = {
        let label = UILabel()
        label.textColor = .purple
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()

    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleReadyPress(sender:)), for: .touchUpInside)
        button.setTitle(OrderConstants.itemReadyButtonTitle, for: .normal)
        button.backgroundColor = .purple
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = ButtonConstants.mediumButtonHeight / 2.0
        return button
    }()

    // MARK: - Stack views

    private var detailLabelsContainer = OrderItemDetailsView()

    /// The order item view (LHS + RHS) excluding the ready button.
    private lazy var itemStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [quantitylabel, detailLabelsContainer])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    /// All the contents of a cell.
    private var contentStackView = UIStackView()

    func set(quantity: String,
             name: String,
             diningOption: String,
             options: String,
             addons: String,
             comment: String,
             isItemPrepared: Bool) {
        quantitylabel.text = String(quantity)
        self.isItemPrepared = isItemPrepared
        detailLabelsContainer.set(name: name,
                                  diningOption: diningOption,
                                  options: options,
                                  addons: addons,
                                  comment: comment)
        setupView()
    }

    private func setupView() {
        if isItemPrepared {
            contentView.alpha = 0.5
            readyButton.removeFromSuperview()
        }

        contentView.addSubview(contentStackView)
        configureConstraints()
    }

    private func configureConstraints() {
        contentStackView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(OrderConstants.orderItemPadding)
            make.left.equalToSuperview().offset(OrderConstants.orderItemPadding)
            make.right.equalToSuperview().offset(-OrderConstants.orderItemPadding)
            make.bottom.equalToSuperview().offset(-OrderConstants.orderItemPadding)
        }

        itemStackView.snp.remakeConstraints { make in
            make.width.equalToSuperview()
        }

        quantitylabel.snp.remakeConstraints { make in
            make.width.equalToSuperview()
                .multipliedBy(OrderConstants.leftPanelRatio)
        }

        detailLabelsContainer.snp.remakeConstraints { make in
            make.width.equalToSuperview()
                .multipliedBy(1 - OrderConstants.leftPanelRatio)
        }

        readyButton.snp.remakeConstraints { make in
            make.height.equalTo(ButtonConstants.mediumButtonHeight)
            guard readyButton.superview != nil else {
                return
            }
            make.width.equalToSuperview()
        }
    }

    @objc
    private func handleReadyPress(sender: Any) {
        delegate?.didTapReady(forCell: self)
    }
}
