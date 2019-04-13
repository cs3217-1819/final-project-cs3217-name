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
class MenuAddonsCollectionViewDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate,
    MenuAddonsTableViewCellProvider {
// swiftlint:enable type_name
    private let choices: [(name: String, price: String)]
    let selectedIndexPath: IndexPath
    private let section: Int

    weak var delegate: MenuAddonsTableViewCellDelegate?

    init(choices: [(name: String, price: String)], value: String, section: Int) {
        self.choices = choices
        let index = choices.firstIndex { $0.name == value } ?? (choices.count - 1)
        self.selectedIndexPath = IndexPath(item: index, section: 0)
        self.section = section
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choices.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: MenuAddonsCollectionViewCell.reuseIdentifier,
                                 for: indexPath)
        guard let cell = reusableCell as? MenuAddonsCollectionViewCell else {
            return reusableCell
        }
        let choice = choices[indexPath.item]
        cell.set(name: choice.name, price: choice.price)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.valueDidSelect(section: section, itemOrQuantity: indexPath.item)
    }

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
