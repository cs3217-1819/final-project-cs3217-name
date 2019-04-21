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
    func add(menuItemIds: [String], toCategory categoryIndex: Int)
    func remove(menuItemIds: [String], fromCategory categoryIndex: Int)

    func getLegalActions(forCategoryAt index: Int)
    func insert(newCategoryName: String, besideCategoryAt index: Int, onLeft: Bool)
    func rename(categoryAt index: Int, to name: String)
    func remove(categoryAt index: Int)

    func reload()
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
        selector.addInteraction(UIDropInteraction(delegate: dropHandler))
        return selector
    }()

    private var collectionViewDataSource: MenuDataSource? {
        didSet {
            collectionView.dataSource = collectionViewDataSource
            collectionView.reloadData()
        }
    }

    private lazy var dragHandler = MenuDragHandler(delegate: self)
    private lazy var dropHandler = CategoryDropHandler(delegate: self)

    // MARK: - Initializers

    init(stallId: String?,
         mediator: MenuToParentOutput?,
         configurator: MenuConfigurator = MenuConfigurator.shared) {

        super.init(collectionViewLayout: UICollectionViewFlowLayout())

        configure(stallId: stallId, mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurator

    private func configure(stallId: String?,
                           mediator: MenuToParentOutput?,
                           configurator: MenuConfigurator = MenuConfigurator.shared) {
        configurator.configure(stallId: stallId, viewController: self, toParentMediator: mediator)

        // Disable content behind nav bar to allow
        // collectionView(_:didEndDisplayingSupplementaryView:forElementOfKind:at:)
        // to report back when a header goes offscreen
        edgesForExtendedLayout = UIRectEdge()

        collectionView.register(MenuItemCollectionViewCell.self,
                                forCellWithReuseIdentifier: MenuViewController.itemCellIdentifier)
        collectionView.register(MenuCategoryHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MenuViewController.headerIdentifier)
        collectionView.backgroundColor = UIColor.Custom.paleGray
        collectionView.alwaysBounceVertical = true
        collectionView.dragDelegate = dragHandler

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 150, height: 100)
            layout.headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 40)
            layout.sectionHeadersPinToVisibleBounds = true
        }

        navigationItem.titleView = categorySelector
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        output?.reload()
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
        guard !collectionView.hasActiveDrag,
            let categories = collectionViewDataSource?.categoryViewModels else {
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
        collectionViewDataSource = MenuDataSource(collectionView: collectionView,
                                                  categories: viewModel.categories,
                                                  cellIdentifier: MenuViewController.itemCellIdentifier,
                                                  headerIdentifier: MenuViewController.headerIdentifier)
    }

    private func promptNewCategoryName(index: Int, onLeft: Bool) {
        let okHandler = { [unowned self] (result: String?) in
            guard let result = result else {
                return
            }
            self.output?.insert(newCategoryName: result, besideCategoryAt: index, onLeft: onLeft)
        }
        let alert = AlertHelper.makeAlertController(title: "New Category Name",
                                                    message: nil,
                                                    textFieldText: "",
                                                    okHandler: okHandler)
        present(alert, animated: true)
    }

    private func promptRenameCategory(index: Int, oldName: String) {
        let okHandler = { [unowned self] (result: String?) in
            guard let result = result else {
                return
            }
            self.output?.rename(categoryAt: index, to: result)
        }
        let alert = AlertHelper.makeAlertController(title: "Rename \"\(oldName)\"",
                                                    message: nil,
                                                    textFieldText: oldName,
                                                    okHandler: okHandler)
        present(alert, animated: true)
    }

    func display(actions: [MenuCategoryAction], forCategoryAt index: Int, name: String) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if actions.contains(.insertLeft) {
            let action = UIAlertAction(title: "Insert New Category on Left", style: .default) { [unowned self] _ in
                self.promptNewCategoryName(index: index, onLeft: true)
            }
            sheet.addAction(action)
        }

        if actions.contains(.insertRight) {
            let action = UIAlertAction(title: "Insert New Category on Right", style: .default) { [unowned self] _ in
                self.promptNewCategoryName(index: index, onLeft: false)
            }
            sheet.addAction(action)
        }

        if actions.contains(.rename) {
            let action = UIAlertAction(title: "Rename", style: .default) { [unowned self] _ in
                self.promptRenameCategory(index: index, oldName: name)
            }
            sheet.addAction(action)
        }

        if actions.contains(.remove) {
            let action = UIAlertAction(title: "Delete Category", style: .destructive) { [unowned self] _ in
                self.output?.remove(categoryAt: index)
            }
            sheet.addAction(action)
        }

        sheet.popoverPresentationController?.sourceView = categorySelector.selectedButton
        present(sheet, animated: true)
    }
}

// MARK: - CategorySelectorDelegate

extension MenuViewController: CategorySelectorDelegate {
    private func scrollToCategory(atIndex idx: Int) {
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

    private func presentActionsForCategory(atIndex idx: Int) {
        output?.getLegalActions(forCategoryAt: idx)
    }

    func categorySelector(_ selector: CategorySelector,
                          didSelectCategory category: String,
                          at idx: Int,
                          wasAlreadySelected: Bool) {
        if wasAlreadySelected {
            presentActionsForCategory(atIndex: idx)
        } else {
            scrollToCategory(atIndex: idx)
        }
    }
}

// MARK: - DragHandlerDelegate

extension MenuViewController: MenuDragHandlerDelegate {
    func dragHandler(_ handler: MenuDragHandler, menuItemIdForIndexPath indexPath: IndexPath) -> String? {
        return collectionViewDataSource?.menuItemViewModel(at: indexPath).id
    }

    func dragHandler(_ handler: MenuDragHandler, willBeginDragSessionForCategoryAtIndex index: Int) {
        enableCategorySelectionFeedback = false
        collectionViewDataSource?.freezeSection(forCategoryAtIndex: index)
        categorySelector.selectedIndex = index
        categorySelector.isRemoving = true
        categorySelector.isSelectionEnabled = false
        // TODO: Disable stall list
    }

    func dragHandlerDidEndDragSession(_ handler: MenuDragHandler) {
        enableCategorySelectionFeedback = true
        collectionViewDataSource?.unfreezeSection()
        categorySelector.isRemoving = false
        categorySelector.isSelectionEnabled = true
        // TODO: Enable stall list
    }
}

// MARK: - CategoryDropHandlerDelegate

extension MenuViewController: CategoryDropHandlerDelegate {
    func dropHandlerDropTarget(_ handler: CategoryDropHandler) -> UIView {
        return categorySelector
    }

    func dropHandler(_ handler: CategoryDropHandler, canDropAt point: CGPoint) -> Bool {
        return categorySelector.categoryInfo(atPoint: point) != nil
    }

    func dropHandler(_ handler: CategoryDropHandler,
                     didDropMenuItemIds menuItemIds: [String],
                     at point: CGPoint) {
        guard let (categoryIndex, isRemove) = categorySelector.categoryInfo(atPoint: point) else {
            return
        }
        if isRemove {
            output?.remove(menuItemIds: menuItemIds, fromCategory: categoryIndex)
        } else {
            output?.add(menuItemIds: menuItemIds, toCategory: categoryIndex)
        }
    }
}
