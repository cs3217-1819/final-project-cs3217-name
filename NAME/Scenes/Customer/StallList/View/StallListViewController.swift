//
//  StallListViewController.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallListViewControllerInput: StallListPresenterOutput {

}

protocol StallListViewControllerOutput {

    func doSomething()
}

final class StallListViewController: UITableViewController {

    var output: StallListViewControllerOutput?
    var router: StallListRouterProtocol?

    // MARK: - Initializers

    init(configurator: StallListConfigurator = StallListConfigurator.shared) {

        super.init(nibName: nil, bundle: nil)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: StallListConfigurator = StallListConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        doSomethingOnLoad()
    }

    // MARK: - Load data

    func doSomethingOnLoad() {

        // TODO: Ask the Interactor to do some work

        output?.doSomething()
    }
}

// MARK: - StallListPresenterOutput

extension StallListViewController: StallListViewControllerInput {

    // MARK: - Display logic

    func displaySomething(viewModel: StallListViewModel) {

        // TODO: Update UI
    }
}

// MARK: - UIViewControllerRestoration

extension StallListViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
