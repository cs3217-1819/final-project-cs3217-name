//
//  BrowseConfigurator.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

final class BrowseConfigurator {

    // MARK: - Singleton

    static let shared: BrowseConfigurator = BrowseConfigurator()

    // MARK: - Configuration

    func configure(viewController: BrowseViewController) {

        let router = BrowseRouter(viewController: viewController)
        let presenter = BrowsePresenter(output: viewController)
        let interactor = BrowseInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router

        viewController.viewControllers = [
            router.stallListViewController(),
            router.menuViewController()
        ]

        viewController.restorationIdentifier = String(describing: type(of: self))
    }
}
