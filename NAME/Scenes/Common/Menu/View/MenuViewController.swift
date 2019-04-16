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

    /// Whether this view controller should update the category selector's selectedIndex.
    ///
    /// Should be set to false when the collection view is automatically scrolling.
    private var enableCategorySelectionFeedback = true

    private lazy var categorySelector: CategorySelector = {
        let selector = CategorySelector()
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.selectorDelegate = self
        return selector
    }()

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

        // Disable content behind nav bar to allow
        // collectionView(_:didEndDisplayingSupplementaryView:forElementOfKind:at:)
        // to report back when a header goes offscreen
        edgesForExtendedLayout = UIRectEdge()

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

        navigationItem.titleView = categorySelector
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func highlightCurrentCategory() {
        let currentCategoryIndex = collectionView
            .indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
            .map { $0.section }.min()
        if categorySelector.selectedIndex != currentCategoryIndex {
            categorySelector.selectedIndex = currentCategoryIndex
        }
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

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if enableCategorySelectionFeedback {
            highlightCurrentCategory()
        }
    }

    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        enableCategorySelectionFeedback = true
        // Delay the category highlight as this callback seems to be called before the scroll view
        // actually ends its animation. Calling highlightCurrentCategory when scrolling animation ends
        // also ensures that the correct category is highlighted if the user spams taps categories.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.highlightCurrentCategory()
        }
    }
}

// MARK: - MenuPresenterOutput

extension MenuViewController: MenuViewControllerInput {
    func displayMenu(viewModel: MenuViewModel) {
        title = viewModel.stall.name
        categorySelector.selectedIndex = 0
        categorySelector.categories = viewModel.categories.map { $0.name }
        collectionViewDataSource = MenuDataSource(categories: viewModel.categories,
                                                  cellIdentifier: MenuViewController.itemCellIdentifier,
                                                  headerIdentifier: MenuViewController.headerIdentifier)
    }
}

// MARK: - CategorySelectorDelegate

extension MenuViewController: CategorySelectorDelegate {
    func categorySelector(_ selector: CategorySelector, didSelectCategory category: String, atIndex idx: Int) {
        guard let headerLayout = collectionView.layoutAttributesForSupplementaryElement(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: idx)) else {
                return
        }

        guard let firstItemLayout = collectionView.layoutAttributesForItem(at: IndexPath(item: 0, section: idx)) else {
            return
        }

        enableCategorySelectionFeedback = false

        let offset = CGPoint(x: firstItemLayout.frame.origin.x,
                             y: firstItemLayout.frame.origin.y - headerLayout.frame.size.height)
        collectionView.setContentOffset(offset, animated: true)
    }
}
