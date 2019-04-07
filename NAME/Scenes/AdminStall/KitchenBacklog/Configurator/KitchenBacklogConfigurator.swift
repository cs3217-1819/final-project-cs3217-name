//
//  KitchenBacklogConfigurator.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class KitchenBacklogConfigurator {
    // MARK: - Singleton
    static let shared: KitchenBacklogConfigurator = KitchenBacklogConfigurator()

    // MARK: - Configuration
    func configure(viewController: KitchenBacklogViewController) {
        let router = KitchenBacklogRouter(viewController: viewController)
        let presenter = KitchenBacklogPresenter(output: viewController)
        let interactor = KitchenBacklogInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router
    }
}
