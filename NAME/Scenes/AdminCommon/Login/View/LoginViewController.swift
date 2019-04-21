//
//  LoginViewController.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit
import SnapKit

protocol LoginViewControllerInput: LoginPresenterOutput {
}

protocol LoginViewControllerOutput {
    func initializeScreen()
    func handleLogin(username: String, password: String)
}

final class LoginViewController: UIViewController {
    var output: LoginViewControllerOutput?
    var router: LoginRouterProtocol?

    private var loginContainerView = LoginContainerView()

    // MARK: - Initializers

    init(configurator: LoginConfigurator = LoginConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: LoginConfigurator = LoginConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
    }

    // MARK: - View lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginContainerView.focusInputField()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Custom.palePurple
        setUpLoginContainer()
    }

    func setUpLoginContainer() {
        view.addSubview(loginContainerView)

        loginContainerView.delegate = self
        loginContainerView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(LoginConstants.maxContainerWidth)
            make.left.greaterThanOrEqualToSuperview().offset(LoginConstants.minContainerMargin).priority(999)
            make.right.greaterThanOrEqualToSuperview().offset(-LoginConstants.minContainerMargin).priority(999)
            make.center.equalToSuperview()
            make.height.equalTo(LoginConstants.containerHeight)
        }
        loginContainerView.backgroundColor = LoginConstants.containerColor
        loginContainerView.layer.cornerRadius = LoginConstants.containerCornerRadius
        loginContainerView.clipsToBounds = true

        output?.initializeScreen()
    }

}

// MARK: - LoginContainerViewDelegate
extension LoginViewController: LoginContainerViewDelegate {
    func didTapLogin(username: String, password: String) {
        output?.handleLogin(username: username, password: password)
    }

    func didTapCancel() {
        router?.navigateBack()
    }
}

// MARK: - LoginPresenterOutput
extension LoginViewController: LoginViewControllerInput {
    func displayLoginContainer(viewModel: LoginViewModel) {
        loginContainerView.viewModel = viewModel
    }

    func displayLoginError() {
        let errorVC = CustomAlertViewController(withTitle: LoginConstants.loginErrorTitle,
                                                withMessage: LoginConstants.loginErrorMessage,
                                                buttonText: nil,
                                                alertType: .error)
        present(errorVC, animated: true)
    }

    func displayStall(withId id: String) {
        router?.navigateToStallView(stallId: id)
    }

    func displayEstablishment(withId id: String) {
        router?.navigateToEstablishmentView(estId: id)
    }
}

extension LoginViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
