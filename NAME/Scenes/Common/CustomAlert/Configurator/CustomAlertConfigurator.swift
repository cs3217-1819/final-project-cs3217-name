//
//  CustomAlertConfigurator.swift
//  NAME
//
//  Created by Caryn Heng on 20/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class CustomAlertConfigurator {
    // MARK: - Singleton
    static let shared: CustomAlertConfigurator = CustomAlertConfigurator()

    // MARK: - Configuration
    func configure(viewController: CustomAlertViewController) {
        let router = CustomAlertRouter(viewController: viewController)
        let presenter = CustomAlertPresenter(output: viewController)
        let interactor = CustomAlertInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router
    }
}
