//
//  MenuDetailViewController.swift
//  NAME
//
//  Created by Julius on 8/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuDetailViewControllerInput: MenuDetailPresenterOutput {

}

protocol MenuDetailViewControllerOutput {
}

final class MenuDetailViewController: UISplitViewController {
    var output: MenuDetailViewControllerOutput?
    var router: MenuDetailRouterProtocol?

    // MARK: - Initializers
    /// Pass `nil` to `menuId` to create a new menu item
    init(menuId: String?,
         isEditable: Bool,
         toParentMediator: MenuDetailToParentOutput?,
         configurator: MenuDetailConfigurator = MenuDetailConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator,
                  menuId: menuId,
                  isEditable: isEditable,
                  toParentMediator: toParentMediator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This should not be called without storyboard.")
    }

    private func configure(configurator: MenuDetailConfigurator = MenuDetailConfigurator.shared,
                           menuId: String?,
                           isEditable: Bool,
                           toParentMediator: MenuDetailToParentOutput?) {
        configurator.configure(viewController: self,
                               menuId: menuId,
                               isEditable: isEditable,
                               toParentMediator: toParentMediator)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        preferredPrimaryColumnWidthFraction = 0.45
        maximumPrimaryColumnWidth = view.bounds.width
    }
}

// MARK: - MenuDetailPresenterOutput
extension MenuDetailViewController: MenuDetailViewControllerInput {
}
