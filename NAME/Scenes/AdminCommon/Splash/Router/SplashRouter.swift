//
//  SplashRouter.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol SplashRouterProtocol {

    var viewController: SplashViewController? { get }

    func navigateToCustomerMenu()
    func navigateToLoginScreen()
}

final class SplashRouter {

    weak var viewController: SplashViewController?

    // MARK: - Initializers

    init(viewController: SplashViewController?) {
        self.viewController = viewController
    }
}

// MARK: - SplashRouterProtocol

extension SplashRouter: SplashRouterProtocol {
    // MARK: - Navigation

    func navigateToCustomerMenu() {
        let customerRootVC = CustomerRootViewController()
        customerRootVC.modalTransitionStyle = .crossDissolve
        viewController?.present(customerRootVC, animated: true)
    }

    func navigateToLoginScreen() {
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        loginVC.modalTransitionStyle = .flipHorizontal
        viewController?.present(loginVC, animated: true)
    }
}
