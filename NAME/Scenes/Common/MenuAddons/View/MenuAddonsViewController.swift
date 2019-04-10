//
//  MenuAddonsViewController.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuAddonsViewControllerInput: MenuAddonsPresenterOutput {

}

protocol MenuAddonsViewControllerOutput {
    func doSomething()
}

final class MenuAddonsViewController: UIViewController {
    var output: MenuAddonsViewControllerOutput?
    var router: MenuAddonsRouterProtocol?

    // MARK: - Initializers
    init(menuId: String, configurator: MenuAddonsConfigurator = MenuAddonsConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure(configurator: MenuAddonsConfigurator = MenuAddonsConfigurator.shared) {
        configurator.configure(viewController: self)
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

// MARK: - MenuAddonsPresenterOutput
extension MenuAddonsViewController: MenuAddonsViewControllerInput {
    func displaySomething(viewModel: MenuAddonsViewModel) {
        // TODO: Update UI
    }
}
