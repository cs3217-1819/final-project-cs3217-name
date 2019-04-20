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
    func menuInfoViewController(menuId: String, isEditable: Bool) -> UIViewController
    func menuAddonsViewController(menuId: String, isEditable: Bool) -> UIViewController
}

final class MenuDetailRouter {
    weak var viewController: MenuDetailViewController?
    unowned var mediator: MenuDetailIntersceneMediator

    // MARK: - Initializers
    init(viewController: MenuDetailViewController?, mediator: MenuDetailIntersceneMediator) {
        self.viewController = viewController
        self.mediator = mediator
    }
}

// MARK: - MenuDetailRouterProtocol

extension MenuDetailRouter: MenuDetailRouterProtocol {
    func menuInfoViewController(menuId: String, isEditable: Bool) -> UIViewController {
        let menuInfoViewController = MenuInfoViewController(menuId: menuId, isEditable: isEditable, mediator: mediator)
        return UINavigationController(rootViewController: menuInfoViewController)
    }

    func menuAddonsViewController(menuId: String, isEditable: Bool) -> UIViewController {
        let menuAddonsViewController = MenuAddonsViewController(menuId: menuId,
                                                                isEditable: isEditable,
                                                                mediator: mediator)
        return UINavigationController(rootViewController: menuAddonsViewController)
    }

    func navigateBack() {
        viewController?.dismiss(animated: true)
    }
}
