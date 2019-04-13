//
//  OrderConfigurator.swift
//  NAME
//
//  Created by Caryn Heng on 10/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class OrderConfigurator {
    // MARK: - Singleton
    static let shared: OrderConfigurator = OrderConfigurator()

    // MARK: - Configuration
    func configure(orderId: String,
                   viewController: OrderViewController,
                   toParentMediator: OrderToParentOutput?,
                   injector: DependencyInjector = appDefaultInjector) {
        let router = OrderRouter(viewController: viewController)
        let presenter = OrderPresenter(output: viewController)
        let interactor = OrderInteractor(output: presenter,
                                         orderId: orderId,
                                         injector: injector,
                                         toParentMediator: toParentMediator)
        toParentMediator?.orderInteractor = interactor

        viewController.output = interactor
        viewController.router = router
    }
}
