//
//  MenuAddonsTableViewCell.swift
//  NAME
//
//  Created by Julius on 10/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

protocol MenuAddonsTableViewCellDelegate: class {
    func valueDidSelect(section: Int, itemOrQuantity: Int)
}

final class MenuAddonsTableViewCell: UITableViewCell {
    private let collectionViewCellIdentifier: String = "collectionViewCellIdentifier"

    var type: MenuAddonsViewModel.MenuOptionTypeViewModel? {
        didSet {
            typeDidChange()
        }
    }
    var value: MenuAddonsViewModel.MenuOptionValueViewModel? {
        didSet {
            valueDidChange()
        }
    }

    /// The section of the IndexPath this cell is located.
    var section: Int?

    weak var delegate: MenuAddonsTableViewCellDelegate?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = MenuAddonsConstants.addonsSize
        let result = UICollectionView(frame: .zero, collectionViewLayout: layout)
        result.dataSource = self
        result.delegate = self
        result.register(MenuAddonsCollectionViewCell.self,
                        forCellWithReuseIdentifier: collectionViewCellIdentifier)
        result.backgroundColor = .white
        return result
    }()

    private lazy var quantityTextField: UITextField = {
        // TODO reuse Derek's quantity
        let result = UITextField(frame: .zero)
        result.text = nil
        result.font = .preferredFont(forTextStyle: .title3)
        result.layer.borderColor = UIColor.black.cgColor
        result.layer.borderWidth = 1.0
        result.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return result
    }()

    private let priceLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.font = .preferredFont(forTextStyle: .subheadline)
        result.textColor = .gray
        return result
    }()

    private func configureCollectionViewConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    private func configureTextFieldConstraints() {
        quantityTextField.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(MenuAddonsConstants.addonsSize)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(quantityTextField.snp.trailing).offset(ConstraintConstants.standardValue)
        }
    }

    private func valueDidChange() {
        guard let type = type, let value = value else {
            return
        }
        switch (type, value) {
        case let (.quantity(price), .quantity(quantity)):
            quantityTextField.text = String(quantity)
            priceLabel.text = price
        case let (.choices(choices), .choice(choice)):
            if let index = choices.firstIndex(where: { $0.name == choice }) {
                collectionView.selectItem(at: IndexPath(item: index, section: 0),
                                          animated: true,
                                          scrollPosition: [])
            }
        default:
            assertionFailure("Dumbo! Why are you passing me different type and value!")
        }
    }

    private func typeDidChange() {
        guard let type = type else {
            return
        }
        switch type {
        case .quantity:
            collectionView.removeFromSuperview()
            addSubview(quantityTextField)
            addSubview(priceLabel)
            configureTextFieldConstraints()
        case .choices:
            quantityTextField.removeFromSuperview()
            priceLabel.removeFromSuperview()
            addSubview(collectionView)
            configureCollectionViewConstraints()
            collectionView.reloadData()
        }
    }

    @objc
    private func textFieldDidChange() {
        guard let quantityString = quantityTextField.text, let quantity = Int(quantityString),
            let section = section else {
            return
        }
        delegate?.valueDidSelect(section: section, itemOrQuantity: quantity)
    }
}

// MARK: - UICollectionViewDataSource
extension MenuAddonsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = type else {
            return 0
        }
        switch type {
        case .quantity: return 1
        case .choices(let choices): return choices.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier,
                                                              for: indexPath)
        guard let cell = reusableCell as? MenuAddonsCollectionViewCell, let type = type else {
            return reusableCell
        }
        switch type {
        case .quantity: break
        case .choices(let choices):
            let choice = choices[indexPath.item]
            cell.set(name: choice.name, price: choice.price)
        }
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - UICollectionViewDelegate
extension MenuAddonsTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let section = section else {
            return
        }
        delegate?.valueDidSelect(section: section, itemOrQuantity: indexPath.item)
    }
}
