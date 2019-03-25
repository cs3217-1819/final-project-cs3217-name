//
//  CustomerRootRouter.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomerRootRouterProtocol {

    weak var viewController: CustomerRootViewController? { get }

    func navigateToSomewhere()
}

final class CustomerRootRouter {

    weak var viewController: CustomerRootViewController?

    // MARK: - Initializers

    init(viewController: CustomerRootViewController?) {

        self.viewController = viewController
    }
}

// MARK: - CustomerRootRouterProtocol

extension CustomerRootRouter: CustomerRootRouterProtocol {

    // MARK: - Navigation

    func navigateToSomewhere() {

    }
}
