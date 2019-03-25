//
//  SplashViewController.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol SplashViewControllerInput: SplashPresenterOutput {

}

protocol SplashViewControllerOutput {

    func doSomething()
}

final class SplashViewController: UIViewController {

    var output: SplashViewControllerOutput!
    var router: SplashRouterProtocol!


    // MARK: - Initializers

    init(configurator: SplashConfigurator = SplashConfigurator.sharedInstance) {

        super.init(nibName: nil, bundle: nil)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        configure()
    }


    // MARK: - Configurator

    private func configure(configurator: SplashConfigurator = SplashConfigurator.sharedInstance) {

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


// MARK: - SplashPresenterOutput

extension SplashViewController: SplashViewControllerInput {


    // MARK: - Display logic

    func displaySomething(viewModel: SplashViewModel) {

        // TODO: Update UI
    }
}
