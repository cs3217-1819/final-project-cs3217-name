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
        return UINavigationController(rootViewController: MenuViewController(mediator: nil))
    }

    func kitchenViewController() -> UIViewController {
        return KitchenBacklogViewController()
    }

    func stallSettingsViewController() -> UIViewController {
        return AdminSettingsViewController()
    }
}
