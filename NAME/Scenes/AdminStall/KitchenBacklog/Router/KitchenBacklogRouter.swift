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
}

final class KitchenBacklogRouter {
    weak var viewController: KitchenBacklogViewController?

    // MARK: - Initializers
    init(viewController: KitchenBacklogViewController?) {
        self.viewController = viewController
    }
}

// MARK: - KitchenBacklogRouterProtocol

extension KitchenBacklogRouter: KitchenBacklogRouterProtocol {

}
