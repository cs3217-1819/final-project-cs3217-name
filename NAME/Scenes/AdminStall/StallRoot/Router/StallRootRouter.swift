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
    func menuViewController(stallId: String) -> UIViewController
    func kitchenViewController(stallId: String) -> UIViewController
    func stallSettingsViewController(stallId: String) -> UIViewController
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

    func menuViewController(stallId: String) -> UIViewController {
        return UINavigationController(rootViewController: MenuViewController(stallId: stallId, mediator: nil))
    }

    func kitchenViewController(stallId: String) -> UIViewController {
        // TODO: Pass stallId into child
        return KitchenBacklogViewController()
    }

    func stallSettingsViewController(stallId: String) -> UIViewController {
        // TODO: Pass stallId into child
        return AdminSettingsViewController()
    }
}
