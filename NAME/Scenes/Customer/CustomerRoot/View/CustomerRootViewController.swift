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

final class CustomerRootViewController: UIViewController {

    var output: CustomerRootViewControllerOutput!
    var router: CustomerRootRouterProtocol!


    // MARK: - Initializers

    init(configurator: CustomerRootConfigurator = CustomerRootConfigurator.sharedInstance) {

        super.init(nibName: nil, bundle: nil)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        configure()
    }


    // MARK: - Configurator

    private func configure(configurator: CustomerRootConfigurator = CustomerRootConfigurator.sharedInstance) {

        configurator.configure(viewController: self)
    }


    // MARK: - View lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        doSomethingOnLoad()
    }


    // MARK: - Load data

    func doSomethingOnLoad() {

        // TODO: Ask the Interactor to do some work

        output.doSomething()
    }
}


// MARK: - CustomerRootPresenterOutput

extension CustomerRootViewController: CustomerRootViewControllerInput {


    // MARK: - Display logic

    func displaySomething(viewModel: CustomerRootViewModel) {

        // TODO: Update UI
    }
}
