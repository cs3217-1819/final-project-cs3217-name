//
//  OrderItemDetailsView.swift
//  NAME
//
//  Created by Caryn Heng on 12/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class OrderItemDetailsView: UIView {

    private let diningOptionLabel = UILabel()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: OrderConstants.orderItemTitleFontSize)
        label.textAlignment = .left
        return label
    }()

    private let optionsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = OrderConstants.optionsHeaderTitle
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = OrderConstants.orderDetailsFontColor
        return label
    }()

    private let optionsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = OrderConstants.orderDetailsFontColor
        label.textAlignment = .left
        return label
    }()

    private let addonsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = OrderConstants.addonsHeaderTitle
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = OrderConstants.orderDetailsFontColor
        return label
    }()

    private let addonsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = OrderConstants.orderDetailsFontColor
        label.textAlignment = .left
        return label
    }()

    private let commentsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = OrderConstants.commentsHeaderTitle
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = OrderConstants.orderDetailsFontColor
        return label
    }()

    private let commentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = OrderConstants.orderDetailsFontColor
        label.textAlignment = .left
        return label
    }()

    // MARK: - Stack views

    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [optionsHeaderLabel, optionsLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var addonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addonsHeaderLabel, addonsLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var commentsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [commentsHeaderLabel, commentsLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let arrangedSubviews = [diningOptionLabel, nameLabel, optionsStackView, addonsStackView, commentsStackView]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = ConstraintConstants.standardValue
        return stackView
    }()

    func set(name: String, diningOption: String, options: String, addons: String, comment: String) {
        nameLabel.text = name
        diningOptionLabel.text = diningOption
        optionsLabel.text = options
        addonsLabel.text = addons
        commentsLabel.text = comment

        setupView()
    }

    private func setupView() {
        addSubview(contentStackView)
        hideEmptySubviews()
        configureConstraints()
    }

    private func hideEmptySubviews() {
        hideViewIfEmptyLabel(view: optionsStackView, label: optionsLabel)
        hideViewIfEmptyLabel(view: addonsStackView, label: addonsLabel)
        hideViewIfEmptyLabel(view: commentsStackView, label: commentsLabel)
    }

    private func hideViewIfEmptyLabel(view: UIView, label: UILabel) {
        view.isHidden = (label.text == "")
    }

    private func configureConstraints() {
        contentStackView.snp.remakeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
