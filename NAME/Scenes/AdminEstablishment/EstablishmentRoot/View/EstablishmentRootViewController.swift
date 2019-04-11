//
//  EstablishmentRootViewController.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol EstablishmentRootViewControllerInput: EstablishmentRootPresenterOutput {
}

protocol EstablishmentRootViewControllerOutput {

}

final class EstablishmentRootViewController: UITabBarController {
    var output: EstablishmentRootViewControllerOutput?
    var router: EstablishmentRootRouterProtocol?

    // MARK: - Initializers
    init(configurator: EstablishmentRootConfigurator = EstablishmentRootConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure(configurator: EstablishmentRootConfigurator = EstablishmentRootConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - EstablishmentRootPresenterOutput
extension EstablishmentRootViewController: EstablishmentRootViewControllerInput {

}

extension EstablishmentRootViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
