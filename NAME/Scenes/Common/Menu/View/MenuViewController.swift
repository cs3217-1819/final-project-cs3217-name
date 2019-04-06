//
//  MenuViewController.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuViewControllerInput: MenuPresenterOutput {

}

protocol MenuViewControllerOutput {

    func doSomething()
}

final class MenuViewController: UICollectionViewController {

    var output: MenuViewControllerOutput?
    var router: MenuRouterProtocol?

    // MARK: - Initializers

    init(mediator: MenuToParentOutput,
         configurator: MenuConfigurator = MenuConfigurator.shared) {

        super.init(collectionViewLayout: UICollectionViewFlowLayout())

        configure(mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurator

    private func configure(mediator: MenuToParentOutput?,
                           configurator: MenuConfigurator = MenuConfigurator.shared) {
        configurator.configure(viewController: self, toParentMediator: mediator)
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

// MARK: - MenuPresenterOutput

extension MenuViewController: MenuViewControllerInput {

    // MARK: - Display logic

    func displaySomething(viewModel: MenuViewModel) {

        // TODO: Update UI
    }
}
