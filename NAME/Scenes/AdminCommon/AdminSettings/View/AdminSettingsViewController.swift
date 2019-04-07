//
//  AdminSettingsViewController.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol AdminSettingsViewControllerInput: AdminSettingsPresenterOutput {

}

protocol AdminSettingsViewControllerOutput {
    func doSomething()
}

final class AdminSettingsViewController: UIViewController {
    var output: AdminSettingsViewControllerOutput?
    var router: AdminSettingsRouterProtocol?

    // MARK: - Initializers
    init(configurator: AdminSettingsConfigurator = AdminSettingsConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure(configurator: AdminSettingsConfigurator = AdminSettingsConfigurator.shared) {
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

// MARK: - AdminSettingsPresenterOutput
extension AdminSettingsViewController: AdminSettingsViewControllerInput {
    func displaySomething(viewModel: AdminSettingsViewModel) {
        // TODO: Update UI
    }
}

extension AdminSettingsViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
