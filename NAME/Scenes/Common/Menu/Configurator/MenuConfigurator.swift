//
//  MenuConfigurator.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class MenuConfigurator {

    // MARK: - Singleton

    static let shared: MenuConfigurator = MenuConfigurator()

    // MARK: - Configuration

    func configure(viewController: MenuViewController,
                   toParentMediator: MenuToParentOutput?) {

        let router = MenuRouter(viewController: viewController)
        let presenter = MenuPresenter(output: viewController)

        let interactor = MenuInteractor(output: presenter,
                                        toParentMediator: toParentMediator)
        toParentMediator?.menuInteractor = interactor

        viewController.output = interactor
        viewController.router = router
    }
}
