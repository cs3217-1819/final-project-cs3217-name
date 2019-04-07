//
//  StallRootRouter.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallRootRouterProtocol {
    var viewController: StallRootViewController? { get }

    func navigateBack()
    func menuViewController() -> UIViewController
    func kitchenViewController() -> UIViewController
    func stallSettingsViewController() -> UIViewController
}

final class StallRootRouter {
    weak var viewController: StallRootViewController?

    // MARK: - Initializers
    init(viewController: StallRootViewController?) {
        self.viewController = viewController
    }
}

// MARK: - StallRootRouterProtocol

extension StallRootRouter: StallRootRouterProtocol {
    func navigateBack() {
        viewController?.dismiss(animated: true)
    }

    func menuViewController() -> UIViewController {
        let viewController = MenuViewController(mediator: nil)
        viewController.tabBarItem = UITabBarItem(title: StallRootConstants.menuTabBarTitle,
                                                 image: nil,
                                                 tag: 0)
        return viewController
    }

    func kitchenViewController() -> UIViewController {
        let viewController = KitchenBacklogViewController()
        viewController.tabBarItem = UITabBarItem(title: StallRootConstants.kitchenTabBarTitle,
                                                 image: nil,
                                                 tag: 1)
        return viewController
    }

    func stallSettingsViewController() -> UIViewController {
        let viewController = AdminSettingsViewController()
        viewController.tabBarItem = UITabBarItem(title: StallRootConstants.settingsTabBarTitle,
                                                 image: nil,
                                                 tag: 2)
        return viewController
    }
}
