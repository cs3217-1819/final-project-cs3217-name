//
//  OrderRouter.swift
//  NAME
//
//  Created by Caryn Heng on 10/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol OrderRouterProtocol {
    var viewController: OrderViewController? { get }
}

final class OrderRouter {
    weak var viewController: OrderViewController?

    // MARK: - Initializers
    init(viewController: OrderViewController?) {
        self.viewController = viewController
    }
}

// MARK: - OrderRouterProtocol

extension OrderRouter: OrderRouterProtocol {
}
