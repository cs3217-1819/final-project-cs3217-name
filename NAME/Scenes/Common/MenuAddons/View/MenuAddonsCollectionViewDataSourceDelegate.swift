//
//  MenuAddonsCollectionViewDataSourceDelegate.swift
//  NAME
//
//  Created by Julius on 13/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable type_name
class MenuAddonsCollectionViewDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
// swiftlint:enable type_name

    private let choices: [(name: String, price: String)]
    let selectedIndexPaths: Set<IndexPath>
    private let section: Int

    weak var delegate: MenuAddonsTableViewCellDelegate?

    private let isEditable: Bool

    init(choices: [(name: String, price: String)], selectedIndices: Set<Int>, section: Int, isEditable: Bool) {
        self.choices = choices
        self.selectedIndexPaths = Set(selectedIndices.map { IndexPath(item: $0, section: 0) })
        self.section = section
        self.isEditable = isEditable
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choices.count + (isEditable ? 1 : 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < choices.count {
            let reusableCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: MenuAddonsCollectionViewCell.reuseIdentifier,
                                     for: indexPath)
            guard let cell = reusableCell as? MenuAddonsCollectionViewCell else {
                return reusableCell
            }

            let choice = choices[indexPath.item]
            cell.set(name: choice.name, price: choice.price)
            cell.isSelected = selectedIndexPaths.contains(indexPath)
            return cell
        } else {
            let reusableCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: MenuAddonsCollectionViewAddCell.reuseIdentifier,
                                     for: indexPath)
            guard let cell = reusableCell as? MenuAddonsCollectionViewAddCell else {
                return reusableCell
            }
            cell.delegate = self
            return cell
        }
    }

    // When cell.isSelected is true, didDeselectRowAtIndexPath is not called, so instead, we use
    // shouldHighlightItemAtIndexPath
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if indexPath.item < choices.count {
            delegate?.valueDidSelect(section: section, itemOrQuantity: indexPath.item)
        }
        return false
    }
}

// MARK: - MenuAddonsTableViewCellProvider
extension MenuAddonsCollectionViewDataSourceDelegate: MenuAddonsTableViewCellProvider {
    func dequeueReusableCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: MenuAddonsTableViewChoiceCell.reuseIdentifier,
                                      for: indexPath)
        guard let cell = reusableCell as? MenuAddonsTableViewChoiceCell else {
            return reusableCell
        }
        cell.set(dataSourceDelegate: self)
        return cell
    }
}

// MARK: - MenuAddonsCollectionViewAddCellDelegate
extension MenuAddonsCollectionViewDataSourceDelegate: MenuAddonsCollectionViewAddCellDelegate {
    func addButtonDidTap() {
        delegate?.addCellDidTap(section: section)
    }
}
