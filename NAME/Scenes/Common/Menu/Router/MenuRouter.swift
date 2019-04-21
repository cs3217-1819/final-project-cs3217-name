//
//  MenuRouter.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuRouterProtocol {

    var viewController: MenuViewController? { get }

    func navigateToMenuDetail(menuId: String, isEditable: Bool)
}

final class MenuRouter {

    weak var viewController: MenuViewController?

    // MARK: - Initializers
    init(viewController: MenuViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MenuRouterProtocol

extension MenuRouter: MenuRouterProtocol {
    // MARK: - Navigation
    func navigateToMenuDetail(menuId: String, isEditable: Bool) {
        let menuDetailViewController = MenuDetailViewController(menuId: menuId, isEditable: isEditable)
        viewController?.present(menuDetailViewController, animated: true)
    }
}
