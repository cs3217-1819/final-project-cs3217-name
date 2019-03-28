//
//  SplashViewController.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit
import SnapKit

protocol SplashViewControllerInput: SplashPresenterOutput {
}

protocol SplashViewControllerOutput {
    func initializeScreen()
}

final class SplashViewController: UIViewController {

    var output: SplashViewControllerOutput!
    var router: SplashRouterProtocol!

    lazy var startButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleStartPress(sender:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers

    init(configurator: SplashConfigurator = SplashConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: SplashConfigurator = SplashConfigurator.shared) {
        configurator.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(startButton)
        startButton.snp.makeConstraints { [unowned self] make in
            make.size.equalTo(self.view)
        }
        doSomethingOnLoad()
    }

    // MARK: - Load data

    func doSomethingOnLoad() {
        // Ask the Interactor to do some work
        output?.initializeScreen()
    }

    // MARK: -

    @objc func handleStartPress(sender: Any) {
        router.navigateToCustomerMenu()
    }
}

// MARK: - SplashPresenterOutput

extension SplashViewController: SplashViewControllerInput {
    // MARK: - Display logic

    func reloadDisplay(viewModel: SplashViewModel) {
        startButton.setTitle(viewModel.startButtonTitle, for: .normal)
    }
}
