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

    func doSomething()
}

final class CustomerRootViewController: UISplitViewController {

    var output: CustomerRootViewControllerOutput?
    var router: CustomerRootRouterProtocol?

    // MARK: - Initializers

    init(configurator: CustomerRootConfigurator = CustomerRootConfigurator.shared) {

        super.init(nibName: nil, bundle: nil)

        configure()
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
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - CustomerRootPresenterOutput

extension CustomerRootViewController: CustomerRootViewControllerInput {

    // MARK: - Display logic

    func displaySomething(viewModel: CustomerRootViewModel) {

        // TODO: Update UI
    }
}

// MARK: - UIViewControllerRestoration

extension CustomerRootViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
