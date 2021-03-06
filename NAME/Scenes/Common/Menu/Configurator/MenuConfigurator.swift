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
                   isEditable: Bool,
                   viewController: MenuViewController,
                   toParentMediator: MenuToParentOutput?,
                   injector: DependencyInjector = appDefaultInjector) {

        let toChildrenMediator = MenuIntersceneMediator()
        let router = MenuRouter(viewController: viewController,
                                mediator: toChildrenMediator)
        let presenter = MenuPresenter(output: viewController)

        let interactor = MenuInteractor(stallId: stallId,
                                        isEditable: isEditable,
                                        output: presenter,
                                        injector: injector,
                                        toParentMediator: toParentMediator,
                                        toChildrenMediator: toChildrenMediator)
        toParentMediator?.menuInteractor = interactor
        toChildrenMediator.selfInteractor = interactor

        viewController.output = interactor
        viewController.router = router
    }
}
