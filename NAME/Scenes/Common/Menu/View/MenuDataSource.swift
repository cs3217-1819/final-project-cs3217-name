//
//  MenuDataSource.swift
//  NAME
//
//  Created by E-Liang Tan on 16/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

final class MenuDataSource: NSObject, UICollectionViewDataSource {
    private unowned var collectionView: UICollectionView
    private let cellIdentifier: String
    private let headerIdentifier: String
    private var frozenSectionIndex: Int?

    let categoryViewModels: [MenuViewModel.MenuCategoryViewModel]

    init(collectionView: UICollectionView,
         categories: [MenuViewModel.MenuCategoryViewModel],
         cellIdentifier: String,
         headerIdentifier: String) {
        self.collectionView = collectionView
        self.categoryViewModels = categories
        self.cellIdentifier = cellIdentifier
        self.headerIdentifier = headerIdentifier
        super.init()
    }

    func freezeSection(forCategoryAtIndex index: Int) {
        if frozenSectionIndex != nil {
            unfreezeSection()
        }

        frozenSectionIndex = index

        collectionView.performBatchUpdates({
            var indices = IndexSet(integersIn: 0..<categoryViewModels.count)
            indices.remove(index)
            collectionView.deleteSections(indices)
        })
    }

    func unfreezeSection() {
        guard let index = frozenSectionIndex else {
            return
        }

        frozenSectionIndex = nil

        collectionView.performBatchUpdates({
            var indices = IndexSet(integersIn: 0..<categoryViewModels.count)
            indices.remove(index)
            collectionView.insertSections(indices)
        }, completion: { [unowned self] _ in
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: index),
                                             at: .centeredVertically,
                                             animated: true)
        })
    }

    /// Returns either the frozen section or the provided section
    private func categoryViewModelToDisplay(forSection section: Int) -> MenuViewModel.MenuCategoryViewModel {
        return categoryViewModels[frozenSectionIndex ?? section]
    }

    func menuItemViewModel(at indexPath: IndexPath) -> MenuViewModel.MenuItemViewModel {
        return categoryViewModelToDisplay(forSection: indexPath.section).items[indexPath.item]
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return frozenSectionIndex == nil ? categoryViewModels.count : 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryViewModelToDisplay(forSection: section).items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let itemCell = cell as? MenuItemCollectionViewCell else {
            return cell
        }
        let itemModel = menuItemViewModel(at: indexPath)
        itemCell.set(name: itemModel.name)
        return itemCell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView
            .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              withReuseIdentifier: headerIdentifier,
                                              for: indexPath)
        guard let categoryHeaderView = headerView as? MenuCategoryHeaderView else {
            return headerView
        }
        categoryHeaderView.text = categoryViewModelToDisplay(forSection: indexPath.section).name
        return categoryHeaderView
    }
}
