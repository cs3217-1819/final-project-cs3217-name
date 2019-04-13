//
//  KitchenBacklogConfigurator.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class KitchenBacklogConfigurator {
    // MARK: - Singleton
    static let shared: KitchenBacklogConfigurator = KitchenBacklogConfigurator()

    // MARK: - Configuration
    func configure(viewController: KitchenBacklogViewController,
                   injector: DependencyInjector = appDefaultInjector) {
        let toChildrenMediator = KitchenBacklogIntersceneMediator()
        let router = KitchenBacklogRouter(viewController: viewController,
                                          mediator: toChildrenMediator)
        let presenter = KitchenBacklogPresenter(output: viewController)
        let interactor = KitchenBacklogInteractor(output: presenter,
                                                  injector: injector,
                                                  toChildrenMediator: toChildrenMediator)
        toChildrenMediator.kitchenBacklogInteractor = interactor

        viewController.output = interactor
        viewController.router = router
    }
}
