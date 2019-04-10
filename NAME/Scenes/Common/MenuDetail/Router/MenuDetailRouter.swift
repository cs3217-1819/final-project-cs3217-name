//
//  MenuDetailRouter.swift
//  NAME
//
//  Created by Julius on 8/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuDetailRouterProtocol {
    var viewController: MenuDetailViewController? { get }

    func navigateBack()
    func menuInfoViewController(menuId: String) -> UIViewController
    func menuAddonsViewController(menuId: String) -> UIViewController
}

final class MenuDetailRouter {
    weak var viewController: MenuDetailViewController?

    // MARK: - Initializers
    init(viewController: MenuDetailViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MenuDetailRouterProtocol

extension MenuDetailRouter: MenuDetailRouterProtocol {
    func menuInfoViewController(menuId: String) -> UIViewController {
        let menuInfoViewController = MenuInfoViewController(menuId: menuId)
        return UINavigationController(rootViewController: menuInfoViewController)
    }

    func menuAddonsViewController(menuId: String) -> UIViewController {
        let menuAddonsViewController = MenuAddonsViewController(menuId: menuId)
        return UINavigationController(rootViewController: menuAddonsViewController)
    }

    func navigateBack() {
        viewController?.dismiss(animated: true)
    }
}
