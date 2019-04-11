//
//  SplashConfigurator.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class SplashConfigurator {
    static let shared: SplashConfigurator = SplashConfigurator()

    func configure(viewController: SplashViewController) {
        let router = SplashRouter(viewController: viewController)
        let presenter = SplashPresenter(output: viewController)
        let interactor = SplashInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router
    }
}
