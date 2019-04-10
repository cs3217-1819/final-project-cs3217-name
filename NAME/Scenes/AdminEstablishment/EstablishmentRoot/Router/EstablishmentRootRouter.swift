//
//  EstablishmentRootRouter.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol EstablishmentRootRouterProtocol {
    var viewController: EstablishmentRootViewController? { get }

    func navigateBack()
    func stallListViewController() -> UIViewController
    func establishmentSettingsViewController() -> UIViewController
}

final class EstablishmentRootRouter {
    weak var viewController: EstablishmentRootViewController?

    // MARK: - Initializers
    init(viewController: EstablishmentRootViewController?) {
        self.viewController = viewController
    }
}

// MARK: - EstablishmentRootRouterProtocol

extension EstablishmentRootRouter: EstablishmentRootRouterProtocol {
    func navigateBack() {
        viewController?.dismiss(animated: true)
    }

    func stallListViewController() -> UIViewController {
        let viewController =
            UINavigationController(rootViewController: StallListViewController(isEstablishmentView: true,
                                                                               mediator: nil))
        viewController.tabBarItem = UITabBarItem(title: EstablishmentRootConstants.stallListTabBarTitle,
                                                 image: nil,
                                                 tag: 0)
        return viewController
    }

    func establishmentSettingsViewController() -> UIViewController {
        let viewController = UINavigationController(rootViewController: AdminSettingsViewController())
        viewController.tabBarItem = UITabBarItem(title: EstablishmentRootConstants.settingsTabBarTitle,
                                                 image: nil,
                                                 tag: 1)
        return viewController
    }
}
