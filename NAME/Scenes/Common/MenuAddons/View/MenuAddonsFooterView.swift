//
//  MenuAddonsFooterView.swift
//  NAME
//
//  Created by Julius on 10/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

protocol MenuAddonsFooterViewDelegate: class {
    func addButtonDidPress(sender: UIButton)
    func quantityDidChange(newValue: Int)
}

final class MenuAddonsFooterView: UIView {
    private let priceLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.font = .preferredFont(forTextStyle: .largeTitle)
        result.textAlignment = .center
        result.adjustsFontForContentSizeCategory = true
        return result
    }()

    private let addButton: UIButton = {
        let result = UIButton(type: .system)
        result.backgroundColor = UIColor.Custom.purple
        result.layer.cornerRadius = CornerRadiusConstants.standardRadius
        result.setTitle(MenuAddonsConstants.addButtonTitle, for: .normal)
        result.setTitleColor(.white, for: .normal)
        result.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        result.addTarget(self, action: #selector(addButtonDidPress(sender:)), for: .touchUpInside)
        return result
    }()

    private let buttonView = UIView()

    private lazy var quantityView: QuantityView = {
        let result = QuantityView(quantity: 1, minimum: 0)
        result.delegate = self
        return result
    }()

    private lazy var stackView: UIStackView = {
        let result = UIStackView(arrangedSubviews: [quantityView, priceLabel, buttonView])
        result.axis = .horizontal
        result.distribution = .fillEqually
        return result
    }()

    weak var delegate: MenuAddonsFooterViewDelegate?

    var price: String? {
        get {
            return priceLabel.text
        }
        set {
            priceLabel.text = newValue
        }
    }

    init(isEditable: Bool) {
        super.init(frame: .zero)

        backgroundColor = MenuAddonsConstants.backgroundColor
        addButton.isHidden = isEditable
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {
        addSubview(stackView)
        buttonView.addSubview(addButton)
    }

    private func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        addButton.snp.makeConstraints { make in
            make.height.equalTo(ButtonConstants.mediumButtonHeight)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(ConstraintConstants.standardValue)
            make.right.equalToSuperview().offset(-ConstraintConstants.standardValue)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assertionFailure("This should not be called without Storyboard.")
    }

    @objc
    private func addButtonDidPress(sender: UIButton) {
        delegate?.addButtonDidPress(sender: sender)
    }
}

// MARK: - QuantityViewDelegate
extension MenuAddonsFooterView: QuantityViewDelegate {
    func valueDidChange(newValue: Int) {
        delegate?.quantityDidChange(newValue: newValue)
    }
}
