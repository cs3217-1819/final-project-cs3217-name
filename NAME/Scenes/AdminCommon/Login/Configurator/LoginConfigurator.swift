//
//  LoginConfigurator.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class LoginConfigurator {

    // MARK: - Singleton

    static let shared: LoginConfigurator = LoginConfigurator()

    // MARK: - Configuration

    func configure(viewController: LoginViewController) {

        let router = LoginRouter(viewController: viewController)
        let presenter = LoginPresenter(output: viewController)
        let interactor = LoginInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router
    }
}
