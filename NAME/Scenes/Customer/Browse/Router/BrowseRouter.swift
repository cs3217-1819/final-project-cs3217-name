//
//  BrowseRouter.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol BrowseRouterProtocol {
    var viewController: BrowseViewController? { get }

    func stallListViewController() -> UIViewController
    func menuViewController() -> UIViewController
}

final class BrowseRouter {
    weak var viewController: BrowseViewController?
    unowned var mediator: BrowseIntersceneMediator

    // MARK: - Initializers

    init(viewController: BrowseViewController?,
         mediator: BrowseIntersceneMediator) {
        self.viewController = viewController
        self.mediator = mediator
    }
}

// MARK: - BrowseRouterProtocol

extension BrowseRouter: BrowseRouterProtocol {
    func stallListViewController() -> UIViewController {
        return UINavigationController(rootViewController: StallListViewController(isEstablishmentView: false,
                                                                                  mediator: mediator))
    }

    func menuViewController() -> UIViewController {
        return UINavigationController(rootViewController: MenuViewController(mediator: mediator))
    }
}
