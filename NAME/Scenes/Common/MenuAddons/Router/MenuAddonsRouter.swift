//
//  MenuAddonsRouter.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuAddonsRouterProtocol {
    var viewController: MenuAddonsViewController? { get }

    func navigateBack()
}

final class MenuAddonsRouter {
    weak var viewController: MenuAddonsViewController?

    // MARK: - Initializers
    init(viewController: MenuAddonsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MenuAddonsRouterProtocol

extension MenuAddonsRouter: MenuAddonsRouterProtocol {
    func navigateBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
