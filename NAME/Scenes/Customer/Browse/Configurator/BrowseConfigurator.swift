//
//  BrowseConfigurator.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class BrowseConfigurator {
    static let shared: BrowseConfigurator = BrowseConfigurator()

    func configure(toParentMediator: BrowseToParentOutput?,
                   viewController: BrowseViewController,
                   injector: DependencyInjector = appDefaultInjector) {
        let toChildrenMediator = BrowseIntersceneMediator()
        let router = BrowseRouter(viewController: viewController,
                                  mediator: toChildrenMediator)
        let presenter = BrowsePresenter(output: viewController)
        let interactor = BrowseInteractor(output: presenter,
                                          injector: injector,
                                          toParentMediator: toParentMediator,
                                          toChildrenMediator: toChildrenMediator)
        toParentMediator?.browseInteractor = interactor
        toChildrenMediator.selfInteractor = interactor

        viewController.output = interactor
        viewController.router = router

        viewController.restorationIdentifier = String(describing: type(of: self))
    }
}
