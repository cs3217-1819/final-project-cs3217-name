//
//  MenuDetailConfigurator.swift
//  NAME
//
//  Created by Julius on 8/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class MenuDetailConfigurator {
    // MARK: - Singleton
    static let shared: MenuDetailConfigurator = MenuDetailConfigurator()

    // MARK: - Configuration
    func configure(viewController: MenuDetailViewController,
                   menuId: String?,
                   isEditable: Bool,
                   injector: DependencyInjector = appDefaultInjector) {
        let toChildrenMediator = MenuDetailIntersceneMediator()
        let router = MenuDetailRouter(viewController: viewController, mediator: toChildrenMediator)
        let presenter = MenuDetailPresenter(output: viewController)
        let interactor = MenuDetailInteractor(output: presenter,
                                              menuId: menuId,
                                              injector: injector,
                                              toChildrenMediator: toChildrenMediator)

        viewController.output = interactor
        viewController.router = router

        viewController.viewControllers = [
            router.menuInfoViewController(menuId: interactor.menuId, isEditable: isEditable),
            router.menuAddonsViewController(menuId: interactor.menuId, isEditable: isEditable)
        ]
    }
}
