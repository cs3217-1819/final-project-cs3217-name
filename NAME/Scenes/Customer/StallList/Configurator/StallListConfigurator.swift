//
//  StallListConfigurator.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class StallListConfigurator {

    // MARK: - Singleton

    static let shared: StallListConfigurator = StallListConfigurator()

    // MARK: - Configuration

    func configure(viewController: StallListViewController,
                   toParentMediator: StallListToParentOutput?,
                   injector: DependencyInjector = appDefaultInjector) {

        let router = StallListRouter(viewController: viewController)
        let presenter = StallListPresenter(output: viewController)

        let interactor = StallListInteractor(output: presenter,
                                             injector: injector,
                                             toParentMediator: toParentMediator)
        toParentMediator?.stallListInteractor = interactor

        viewController.output = interactor
        viewController.router = router
    }
}
