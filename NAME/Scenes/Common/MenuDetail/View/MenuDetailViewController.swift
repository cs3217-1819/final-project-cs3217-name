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
    init(menuId: String, configurator: MenuDetailConfigurator = MenuDetailConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator, menuId: menuId)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assertionFailure("This should not be called without storyboard.")
    }

    private func configure(configurator: MenuDetailConfigurator = MenuDetailConfigurator.shared, menuId: String) {
        configurator.configure(viewController: self, menuId: menuId)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        preferredPrimaryColumnWidthFraction = 0.5
        maximumPrimaryColumnWidth = view.bounds.width
    }
}

// MARK: - MenuDetailPresenterOutput
extension MenuDetailViewController: MenuDetailViewControllerInput {
}
