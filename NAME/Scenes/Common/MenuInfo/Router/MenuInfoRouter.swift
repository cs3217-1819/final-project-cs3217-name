//
//  MenuInfoRouter.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuInfoRouterProtocol {
    var viewController: MenuInfoViewController? { get }

    func navigateBack()
}

final class MenuInfoRouter {
    weak var viewController: MenuInfoViewController?

    // MARK: - Initializers
    init(viewController: MenuInfoViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MenuInfoRouterProtocol

extension MenuInfoRouter: MenuInfoRouterProtocol {
    func navigateBack() {
        viewController?.dismiss(animated: true)
    }
}
