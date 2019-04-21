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

    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.Custom.darkPurple, for: .normal)
        button.addTarget(self, action: #selector(handleStartPress(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let result = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapToLogin(sender:)))
        result.numberOfTapsRequired = SplashConstants.numTapsToLoginScreen
        return result
    }()

    private lazy var tapToLoginArea: UIView = {
        let tapArea = UIView()
        tapArea.backgroundColor = .clear
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

        view.addGestureRecognizer(tapRecognizer)
        view.backgroundColor = UIColor.Custom.palePurple
        view.addSubview(startButton)
        view.addSubview(tapToLoginArea)
        configureConstraints()
        output?.initializeScreen()
    }

    private func configureConstraints() {
        startButton.snp.makeConstraints { [unowned self] make in
            make.size.equalTo(self.view)
        }

        tapToLoginArea.snp.makeConstraints { [unowned self] make in
            make.size.equalTo(CGSize(width: SplashConstants.tapAreaWidth,
                                     height: SplashConstants.tapAreaHeight))
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
        }
    }

    // MARK: -

    @objc
    func handleStartPress(sender: UIButton) {
        router?.navigateToCustomerMenu()
    }

    @objc
    func handleTapToLogin(sender: UITapGestureRecognizer) {
        let location = sender.location(in: tapToLoginArea)
        guard tapToLoginArea.bounds.contains(location) else {
            return
        }
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
