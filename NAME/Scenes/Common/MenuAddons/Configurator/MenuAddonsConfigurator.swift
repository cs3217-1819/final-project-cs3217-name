//
//  MenuAddonsConfigurator.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class MenuAddonsConfigurator {
    // MARK: - Singleton
    static let shared: MenuAddonsConfigurator = MenuAddonsConfigurator()

    // MARK: - Configuration
    func configure(viewController: MenuAddonsViewController,
                   menuId: String,
                   toParentMediator: MenuAddonsToParentOutput?) {
        let router = MenuAddonsRouter(viewController: viewController)
        let presenter = MenuAddonsPresenter(output: viewController)
        let interactor = MenuAddonsInteractor(output: presenter, menuId: menuId, toParentMediator: toParentMediator)

        toParentMediator?.menuAddonsInteractor = interactor

        viewController.output = interactor
        viewController.router = router
    }
}
