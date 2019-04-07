//
//  AdminSettingsConfigurator.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class AdminSettingsConfigurator {
    // MARK: - Singleton
    static let shared: AdminSettingsConfigurator = AdminSettingsConfigurator()

    // MARK: - Configuration
    func configure(viewController: AdminSettingsViewController) {
        let router = AdminSettingsRouter(viewController: viewController)
        let presenter = AdminSettingsPresenter(output: viewController)
        let interactor = AdminSettingsInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router
    }
}
