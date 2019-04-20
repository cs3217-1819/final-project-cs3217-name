//
//  CustomAlertRouter.swift
//  NAME
//
//  Created by Caryn Heng on 20/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomAlertRouterProtocol {
    var viewController: CustomAlertViewController? { get }

    func navigateBack()
}

final class CustomAlertRouter {
    weak var viewController: CustomAlertViewController?

    // MARK: - Initializers
    init(viewController: CustomAlertViewController?) {
        self.viewController = viewController
    }
}

// MARK: - CustomAlertRouterProtocol

extension CustomAlertRouter: CustomAlertRouterProtocol {
    func navigateBack() {
        viewController?.dismiss(animated: true)
    }
}
