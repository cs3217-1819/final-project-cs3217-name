//
//  LoginRouter.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol LoginRouterProtocol {

    var viewController: LoginViewController? { get }

    func navigateBack()
    func navigateToStallView()
    func navigateToEstablishmentView()
}

final class LoginRouter {

    weak var viewController: LoginViewController?

    // MARK: - Initializers

    init(viewController: LoginViewController?) {

        self.viewController = viewController
    }
}

// MARK: - LoginRouterProtocol

extension LoginRouter: LoginRouterProtocol {

    func navigateBack() {
        viewController?.dismiss(animated: true)
    }

    func navigateToStallView() {
        let stallRootVC = StallRootViewController()
        viewController?.navigationController?.pushViewController(stallRootVC, animated: true)
    }

    func navigateToEstablishmentView() {
        let establishmentRootVC = EstablishmentRootViewController()
        viewController?.navigationController?.pushViewController(establishmentRootVC, animated: true)
    }
}
