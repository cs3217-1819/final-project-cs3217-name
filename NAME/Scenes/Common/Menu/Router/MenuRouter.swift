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

    func navigateToMenuDetail(menuId: String?, isEditable: Bool)
}

final class MenuRouter {
    weak var viewController: MenuViewController?
    unowned var mediator: MenuIntersceneMediator

    // MARK: - Initializers
    init(viewController: MenuViewController?,
         mediator: MenuIntersceneMediator) {
        self.viewController = viewController
        self.mediator = mediator
    }
}

// MARK: - MenuRouterProtocol

extension MenuRouter: MenuRouterProtocol {
    // MARK: - Navigation
    func navigateToMenuDetail(menuId: String?, isEditable: Bool) {
        let menuDetailViewController = MenuDetailViewController(menuId: menuId,
                                                                isEditable: isEditable,
                                                                toParentMediator: mediator)
        viewController?.present(menuDetailViewController, animated: true)
    }
}
