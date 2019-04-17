//
//  MenuInfoConfigurator.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class MenuInfoConfigurator {
    // MARK: - Singleton
    static let shared: MenuInfoConfigurator = MenuInfoConfigurator()

    // MARK: - Configuration
    func configure(viewController: MenuInfoViewController,
                   menuId: String,
                   toParentMediator: MenuInfoToParentOutput?,
                   injector: DependencyInjector = appDefaultInjector) {
        let router = MenuInfoRouter(viewController: viewController)
        let presenter = MenuInfoPresenter(output: viewController)
        let interactor = MenuInfoInteractor(output: presenter, menuId: menuId,
                                            injector: injector, toParentMediator: toParentMediator)

        toParentMediator?.menuInfoInteractor = interactor

        viewController.output = interactor
        viewController.router = router
    }
}
