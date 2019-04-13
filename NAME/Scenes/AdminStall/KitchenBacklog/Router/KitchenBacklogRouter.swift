//
//  KitchenBacklogRouter.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol KitchenBacklogRouterProtocol {
    var viewController: KitchenBacklogViewController? { get }

    func orderViewController(orderId: String) -> UIViewController
}

final class KitchenBacklogRouter {
    weak var viewController: KitchenBacklogViewController?
    weak var mediator: KitchenBacklogIntersceneMediator?

    // MARK: - Initializers
    init(viewController: KitchenBacklogViewController?,
         mediator: KitchenBacklogIntersceneMediator?) {
        self.viewController = viewController
        self.mediator = mediator
    }
}

// MARK: - KitchenBacklogRouterProtocol

extension KitchenBacklogRouter: KitchenBacklogRouterProtocol {
    func orderViewController(orderId: String) -> UIViewController {
        return OrderViewController(orderId: orderId, mediator: mediator)
    }
}
