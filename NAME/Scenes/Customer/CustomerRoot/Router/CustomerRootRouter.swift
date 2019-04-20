//
//  CustomerRootRouter.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomerRootRouterProtocol {
    var viewController: CustomerRootViewController? { get }

    func navigateBack()
    func browseViewController() -> UIViewController
    func cartViewController() -> UIViewController
}

final class CustomerRootRouter {
    weak var viewController: CustomerRootViewController?
    unowned var mediator: CustomerRootIntersceneMediator

    init(viewController: CustomerRootViewController?,
         mediator: CustomerRootIntersceneMediator) {
        self.viewController = viewController
        self.mediator = mediator
    }
}

// MARK: - CustomerRootRouterProtocol

extension CustomerRootRouter: CustomerRootRouterProtocol {
    func navigateBack() {
        viewController?.dismiss(animated: true)
    }

    func browseViewController() -> UIViewController {
        return BrowseViewController(toParentMediator: mediator)
    }

    func cartViewController() -> UIViewController {
        // TODO: Caryn to implement cart controller
        return UINavigationController(rootViewController: UITableViewController(style: .plain))
    }
}
