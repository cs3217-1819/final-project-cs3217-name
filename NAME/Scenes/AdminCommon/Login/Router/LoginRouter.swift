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
    func navigateToStallView(stallId: String)
    func navigateToEstablishmentView(estId: String)
}

final class LoginRouter {
    weak var viewController: LoginViewController?

    init(viewController: LoginViewController?) {
        self.viewController = viewController
    }
}

// MARK: - LoginRouterProtocol

extension LoginRouter: LoginRouterProtocol {
    func navigateBack() {
        viewController?.dismiss(animated: true)
    }

    func navigateToStallView(stallId: String) {
        let stallRootVC = StallRootViewController(stallId: stallId)
        viewController?.present(stallRootVC, animated: true)
    }

    func navigateToEstablishmentView(estId: String) {
        let establishmentRootVC = EstablishmentRootViewController(estId: estId)
        viewController?.present(establishmentRootVC, animated: true)
    }
}
