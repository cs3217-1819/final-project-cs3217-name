//
//  CustomerRootViewController.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomerRootViewControllerInput: CustomerRootPresenterOutput {

}

protocol CustomerRootViewControllerOutput {
}

final class CustomerRootViewController: UISplitViewController {

    var output: CustomerRootViewControllerOutput?
    var router: CustomerRootRouterProtocol?

    // MARK: - Initializers

    init(configurator: CustomerRootConfigurator = CustomerRootConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: CustomerRootConfigurator = CustomerRootConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
        maximumPrimaryColumnWidth = CustomerCommonConstants.primaryWidth
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - CustomerRootPresenterOutput

extension CustomerRootViewController: CustomerRootViewControllerInput {
    func endSession() {
        router?.navigateBack()
    }
}

// MARK: - UIViewControllerRestoration

extension CustomerRootViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
