//
//  MenuConfigurator.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class MenuConfigurator {
    static let shared: MenuConfigurator = MenuConfigurator()

    func configure(stallId: String?,
                   viewController: MenuViewController,
                   toParentMediator: MenuToParentOutput?,
                   injector: DependencyInjector = appDefaultInjector) {

        let router = MenuRouter(viewController: viewController)
        let presenter = MenuPresenter(output: viewController)

        let interactor = MenuInteractor(stallId: stallId,
                                        output: presenter,
                                        injector: injector,
                                        toParentMediator: toParentMediator)
        toParentMediator?.menuInteractor = interactor

        viewController.output = interactor
        viewController.router = router
    }
}
