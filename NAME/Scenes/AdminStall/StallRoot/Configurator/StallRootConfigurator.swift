//
//  StallRootConfigurator.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class StallRootConfigurator {
    // MARK: - Singleton
    static let shared: StallRootConfigurator = StallRootConfigurator()

    // MARK: - Configuration
    func configure(viewController: StallRootViewController) {
        let router = StallRootRouter(viewController: viewController)
        let presenter = StallRootPresenter(output: viewController)
        let interactor = StallRootInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router

        viewController.viewControllers = [
            router.menuViewController(),
            router.kitchenViewController(),
            router.stallSettingsViewController()
        ]
    }
}
