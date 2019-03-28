//
//  StallListRouter.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallListRouterProtocol {

    var viewController: StallListViewController? { get }

    func navigateToSomewhere()
}

final class StallListRouter {

    weak var viewController: StallListViewController?

    // MARK: - Initializers

    init(viewController: StallListViewController?) {

        self.viewController = viewController
    }
}

// MARK: - StallListRouterProtocol

extension StallListRouter: StallListRouterProtocol {

    // MARK: - Navigation

    func navigateToSomewhere() {

    }
}