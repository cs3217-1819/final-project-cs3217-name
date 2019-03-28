//
//  CustomerRootConfigurator.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class CustomerRootConfigurator {

    // MARK: - Singleton

    static let shared: CustomerRootConfigurator = CustomerRootConfigurator()

    // MARK: - Configuration

    func configure(viewController: CustomerRootViewController) {

        let router = CustomerRootRouter(viewController: viewController)
        let presenter = CustomerRootPresenter(output: viewController)
        let interactor = CustomerRootInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router
    }
}
