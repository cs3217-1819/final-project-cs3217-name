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

    private let choices: [MenuAddonsViewModel.Choice]
    let selectedIndexPaths: Set<IndexPath>
    private let section: Int

    weak var delegate: MenuAddonsTableViewCellDelegate?

    private let isEditable: Bool
    private let isReorderable: Bool

    init(choices: [MenuAddonsViewModel.Choice], selectedIndices: Set<Int>, section: Int, isEditable: Bool, isReorderable: Bool) {
        self.choices = choices
        self.selectedIndexPaths = Set(selectedIndices.map { IndexPath(item: $0, section: 0) })
        self.section = section
        self.isEditable = isEditable
        self.isReorderable = isReorderable
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choices.count + (isEditable ? 1 : 0)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
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

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return isReorderable
    }

    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath) {
        delegate?.moveValue(section: section, fromItem: sourceIndexPath.item, toItem: destinationIndexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView,
                        targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath,
                        toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        guard proposedIndexPath.item < choices.count else {
            return IndexPath(item: choices.count - 1, section: 0)
        }
        return proposedIndexPath
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

// MARK: - MenuAddonsTableViewChoiceCellDelegate
extension MenuAddonsCollectionViewDataSourceDelegate: MenuAddonsTableViewChoiceCellDelegate {
    var shouldPreferSingleTap: Bool {
        return isEditable
    }

    func collectionViewDidDoubleTap(_ collectionView: UICollectionView, gesture: UITapGestureRecognizer) {
        guard isEditable && isReorderable, gesture.state == .ended else {
            return
        }
        let location = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location) else {
            return
        }
        delegate?.deleteValue(section: section, item: indexPath.item, title: choices[indexPath.item].name)
    }

    func collectionViewDidLongPress(_ collectionView: UICollectionView, gesture: UILongPressGestureRecognizer) {
        guard isEditable && isReorderable else {
            return
        }
        let location = gesture.location(in: collectionView)
        switch gesture.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: location) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    func collectionViewDidTap(_ collectionView: UICollectionView, gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location) else {
            return
        }
        if indexPath.item < choices.count {
            delegate?.valueDidSelect(section: section, itemOrQuantity: indexPath.item)
        }
    }
}
