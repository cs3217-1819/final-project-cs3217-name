//
//  CustomerRootConfigurator.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class CustomerRootConfigurator {
    static let shared: CustomerRootConfigurator = CustomerRootConfigurator()

    func configure(viewController: CustomerRootViewController) {
        let toChildrenMediator = CustomerRootIntersceneMediator()
        let router = CustomerRootRouter(viewController: viewController,
                                        mediator: toChildrenMediator)
        let presenter = CustomerRootPresenter(output: viewController)
        let interactor = CustomerRootInteractor(output: presenter,
                                                toChildrenMediator: toChildrenMediator)
        toChildrenMediator.selfInteractor = interactor

        viewController.output = interactor
        viewController.router = router

        viewController.viewControllers = [
            router.cartViewController(), // Right pane
            router.browseViewController() // Left pane
        ]

        viewController.primaryEdge = .trailing // Cart in thinner column on right
    }
}
