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
        let stallListVC = StallListViewController(isEstablishmentView: true, mediator: nil)
        return UINavigationController(rootViewController: stallListVC)
    }

    func establishmentSettingsViewController() -> UIViewController {
        return UINavigationController(rootViewController: AdminSettingsViewController())
    }
}
