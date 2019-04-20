//
//  EstablishmentRootConfigurator.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class EstablishmentRootConfigurator {
    // MARK: - Singleton
    static let shared: EstablishmentRootConfigurator = EstablishmentRootConfigurator()

    // MARK: - Configuration
    func configure(viewController: EstablishmentRootViewController) {
        let router = EstablishmentRootRouter(viewController: viewController)
        let presenter = EstablishmentRootPresenter(output: viewController)
        let interactor = EstablishmentRootInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router
    }
}
