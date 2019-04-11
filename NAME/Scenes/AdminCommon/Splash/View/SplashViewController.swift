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

    var output: SplashViewControllerOutput?
    var router: SplashRouterProtocol?

    lazy var startButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleStartPress(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var tapToLoginArea: UIView = {
        let tapArea = UIView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapToLogin(sender:)))
        tapRecognizer.numberOfTapsRequired = SplashConstants.numTapsToLoginScreen
        tapArea.addGestureRecognizer(tapRecognizer)
        tapArea.backgroundColor = .white
        return tapArea
    }()

    // MARK: - Initializers

    init(configurator: SplashConfigurator = SplashConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: SplashConfigurator = SplashConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(startButton)
        startButton.snp.makeConstraints { [unowned self] make in
            make.size.equalTo(self.view)
        }

        view.addSubview(tapToLoginArea)
        tapToLoginArea.snp.makeConstraints { [unowned self] make in
            make.size.equalTo(CGSize(width: SplashConstants.tapAreaWidth,
                                     height: SplashConstants.tapAreaHeight))
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
        }

        output?.initializeScreen()
    }

    // MARK: -

    @objc
    func handleStartPress(sender: Any) {
        router?.navigateToCustomerMenu()
    }

    @objc
    func handleTapToLogin(sender: Any) {
        router?.navigateToLoginScreen()
    }
}

// MARK: - SplashPresenterOutput

extension SplashViewController: SplashViewControllerInput {
    func reloadDisplay(viewModel: SplashViewModel) {
        startButton.setTitle(viewModel.startButtonTitle, for: .normal)
    }
}

// MARK: - UIViewControllerRestoration

extension SplashViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
}
