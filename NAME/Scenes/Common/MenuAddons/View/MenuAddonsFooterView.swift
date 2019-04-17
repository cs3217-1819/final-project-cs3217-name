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
        result.setTitle(MenuAddonsConstants.addButtonTitle, for: .normal)
        result.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        result.contentHorizontalAlignment = .center
        result.contentVerticalAlignment = .center
        result.addTarget(self, action: #selector(addButtonDidPress(sender:)), for: .touchUpInside)
        return result
    }()

    private lazy var quantityView: QuantityView = {
        let result = QuantityView(quantity: 1, minimum: 0)
        result.delegate = self
        return result
    }()

    private lazy var stackView: UIStackView = {
        let result = UIStackView(arrangedSubviews: [quantityView, priceLabel, addButton])
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

    init() {
        super.init(frame: .zero)

        backgroundColor = .white
        addSubview(stackView)
        configureConstraints()
    }

    private func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
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
