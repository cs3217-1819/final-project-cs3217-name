//
//  MenuAddonsConfigurator.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class MenuAddonsConfigurator {
    // MARK: - Singleton
    static let shared: MenuAddonsConfigurator = MenuAddonsConfigurator()

    // MARK: - Configuration
    func configure(viewController: MenuAddonsViewController) {
        let router = MenuAddonsRouter(viewController: viewController)
        let presenter = MenuAddonsPresenter(output: viewController)
        let interactor = MenuAddonsInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router
    }
}
