//
//  AdminSettingsRouter.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol AdminSettingsRouterProtocol {
    var viewController: AdminSettingsViewController? { get }

    func navigateToSomewhere()
}

final class AdminSettingsRouter {
    weak var viewController: AdminSettingsViewController?

    // MARK: - Initializers
    init(viewController: AdminSettingsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - AdminSettingsRouterProtocol

extension AdminSettingsRouter: AdminSettingsRouterProtocol {
    func navigateToSomewhere() {

    }
}
