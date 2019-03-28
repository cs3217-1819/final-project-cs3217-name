//
//  BrowseViewController.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol BrowseViewControllerInput: BrowsePresenterOutput {

}

protocol BrowseViewControllerOutput {

    func doSomething()
}

final class BrowseViewController: UISplitViewController {

    var output: BrowseViewControllerOutput?
    var router: BrowseRouterProtocol?

    // MARK: - Initializers

    init(configurator: BrowseConfigurator = BrowseConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: BrowseConfigurator = BrowseConfigurator.shared) {
        configurator.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - BrowsePresenterOutput

extension BrowseViewController: BrowseViewControllerInput {
    // MARK: - Display logic

    func displaySomething(viewModel: BrowseViewModel) {
        // TODO: Update UI
    }
}
