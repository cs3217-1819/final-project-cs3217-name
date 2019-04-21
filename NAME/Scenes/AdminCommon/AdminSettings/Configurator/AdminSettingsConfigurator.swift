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
    func configure(id: String,
                   type: SettingsType,
                   viewController: AdminSettingsViewController,
                   injector: DependencyInjector = appDefaultInjector) {
        let router = AdminSettingsRouter(viewController: viewController)
        let presenter = AdminSettingsPresenter(output: viewController)
        let interactor = AdminSettingsInteractor(id: id,
                                                 type: type,
                                                 output: presenter,
                                                 injector: injector)

        viewController.output = interactor
        viewController.router = router
    }
}
