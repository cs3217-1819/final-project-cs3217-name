//
//  MenuViewController.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuViewControllerInput: MenuPresenterOutput {
}

protocol MenuViewControllerOutput {

}

private class MenuDataSource: NSObject, UICollectionViewDataSource {
    private let cellIdentifier: String
    private let headerIdentifier: String

    fileprivate let categoryViewModels: [MenuViewModel.MenuCategoryViewModel]

    init(categories: [MenuViewModel.MenuCategoryViewModel], cellIdentifier: String, headerIdentifier: String) {
        self.categoryViewModels = categories
        self.cellIdentifier = cellIdentifier
        self.headerIdentifier = headerIdentifier
        super.init()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categoryViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryViewModels[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let itemCell = cell as? MenuItemCollectionViewCell else {
            return cell
        }
        let itemModel = categoryViewModels[indexPath.section].items[indexPath.item]
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
        categoryHeaderView.text = categoryViewModels[indexPath.section].name
        return categoryHeaderView
    }
}

final class MenuViewController: UICollectionViewController {
    private static let itemCellIdentifier = "itemCellIdentifier"
    private static let headerIdentifier = "headerIdentifier"

    var output: MenuViewControllerOutput?
    var router: MenuRouterProtocol?

    private var collectionViewDataSource: MenuDataSource? {
        didSet {
            collectionView.dataSource = collectionViewDataSource
            collectionView.reloadData()
        }
    }

    // MARK: - Initializers

    init(mediator: MenuToParentOutput?,
         configurator: MenuConfigurator = MenuConfigurator.shared) {

        super.init(collectionViewLayout: UICollectionViewFlowLayout())

        configure(mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurator

    private func configure(mediator: MenuToParentOutput?,
                           configurator: MenuConfigurator = MenuConfigurator.shared) {
        configurator.configure(viewController: self, toParentMediator: mediator)

        collectionView.register(MenuItemCollectionViewCell.self,
                                forCellWithReuseIdentifier: MenuViewController.itemCellIdentifier)
        collectionView.register(MenuCategoryHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MenuViewController.headerIdentifier)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 30
            layout.itemSize = CGSize(width: 200, height: 100)
            layout.headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 40)
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UICollectionViewDelegate
extension MenuViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let categories = collectionViewDataSource?.categoryViewModels else {
            return
        }
        router?.navigateToMenuDetail(menuId: categories[indexPath.section].items[indexPath.item].id)
    }
}

// MARK: - MenuPresenterOutput

extension MenuViewController: MenuViewControllerInput {
    func displayMenu(viewModel: MenuViewModel) {
        title = viewModel.stall.name
        collectionViewDataSource = MenuDataSource(categories: viewModel.categories,
                                                  cellIdentifier: MenuViewController.itemCellIdentifier,
                                                  headerIdentifier: MenuViewController.headerIdentifier)
    }
}
