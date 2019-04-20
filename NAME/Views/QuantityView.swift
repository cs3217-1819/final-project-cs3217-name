//
//  QuantityView.swift
//  NAME
//
//  Created by Julius on 13/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

protocol QuantityViewDelegate: class {
    func valueDidChange(newValue: Int)
}

class QuantityView: UIView {
    weak var delegate: QuantityViewDelegate?

    private let titleLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.font = .preferredFont(forTextStyle: .body)
        result.text = QuantityViewConstants.title
        return result
    }()

    private lazy var increaseButton: UIButton = {
        let result = UIButton(type: .system)
        result.contentHorizontalAlignment = .center
        result.setTitle(QuantityViewConstants.increaseQuantityTitle, for: .normal)
        result.setTitleColor(.gray, for: .normal)
        result.addTarget(self, action: #selector(increaseButtonDidTap), for: .touchUpInside)
        return result
    }()

    private lazy var decreaseButton: UIButton = {
        let result = UIButton(type: .system)
        result.contentHorizontalAlignment = .center
        result.setTitle(QuantityViewConstants.decreaseQuantityTitle, for: .normal)
        result.setTitleColor(.gray, for: .normal)
        result.addTarget(self, action: #selector(decreaseButtonDidTap), for: .touchUpInside)
        return result
    }()

    private lazy var quantityLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.textAlignment = .center
        result.font = UIFont.boldSystemFont(ofSize: QuantityViewConstants.quantityFontSize)
        result.textColor = UIColor.Custom.deepPurple
        result.text = String(quantity)
        return result
    }()

    var quantity: Int {
        didSet {
            quantity = max(quantity, minimum)
            quantity = min(quantity, maximum)
            quantityLabel.text = String(quantity)
        }
    }

    var maximum: Int
    var minimum: Int

    init(quantity: Int = 0, minimum: Int = .min, maximum: Int = .max) {
        self.quantity = quantity
        self.minimum = minimum
        self.maximum = maximum

        super.init(frame: .zero)

        addSubview(titleLabel)
        addSubview(increaseButton)
        addSubview(decreaseButton)
        addSubview(quantityLabel)

        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(quantityLabel)
            make.leading.equalToSuperview().offset(ConstraintConstants.standardValue)
            make.size.equalTo(titleLabel.intrinsicContentSize)
        }
        increaseButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalTo(quantityLabel)
            make.centerX.equalTo(quantityLabel)
        }
        quantityLabel.snp.makeConstraints { make in
            make.top.equalTo(increaseButton.snp.bottom)
            make.leading.equalTo(titleLabel.snp.trailing).offset(ConstraintConstants.standardValue)
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalTo(QuantityViewConstants.quantityWidth)
            make.trailing.lessThanOrEqualToSuperview().offset(-ConstraintConstants.standardValue)
        }
        decreaseButton.snp.makeConstraints { make in
            make.top.equalTo(quantityLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.centerX.equalTo(quantityLabel)
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalTo(quantityLabel)
        }
    }

    @objc
    private func increaseButtonDidTap() {
        quantity += 1
        delegate?.valueDidChange(newValue: quantity)
    }

    @objc
    private func decreaseButtonDidTap() {
        quantity -= 1
        delegate?.valueDidChange(newValue: quantity)
    }
}
