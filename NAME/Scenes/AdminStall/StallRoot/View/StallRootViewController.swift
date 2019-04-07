//
//  StallRootViewController.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallRootViewControllerInput: StallRootPresenterOutput {

}

protocol StallRootViewControllerOutput {
    func doSomething()
}

final class StallRootViewController: UITabBarController {
    var output: StallRootViewControllerOutput?
    var router: StallRootRouterProtocol?

    // MARK: - Initializers
    init(configurator: StallRootConfigurator = StallRootConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure(configurator: StallRootConfigurator = StallRootConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomethingOnLoad()
    }

    func doSomethingOnLoad() {
        // TODO: Ask the Interactor to do some work
        output?.doSomething()
    }
}

// MARK: - StallRootPresenterOutput
extension StallRootViewController: StallRootViewControllerInput {
    func displaySomething(viewModel: StallRootViewModel) {
        // TODO: Update UI
    }
}

extension StallRootViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
