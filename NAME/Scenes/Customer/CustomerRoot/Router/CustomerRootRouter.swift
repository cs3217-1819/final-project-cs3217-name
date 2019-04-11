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

    init(viewController: CustomerRootViewController?) {
        self.viewController = viewController
    }
}

// MARK: - CustomerRootRouterProtocol

extension CustomerRootRouter: CustomerRootRouterProtocol {
    func navigateBack() {
        viewController?.dismiss(animated: true)
    }

    func browseViewController() -> UIViewController {
        return BrowseViewController()
    }

    func cartViewController() -> UIViewController {
        // TODO: Caryn to implement cart controller
        return UINavigationController(rootViewController: UITableViewController(style: .plain))
    }
}
