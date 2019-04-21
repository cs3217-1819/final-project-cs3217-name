//
//  LoginContainerView.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

protocol LoginContainerViewDelegate: class {
    func didTapCancel()
    func didTapLogin(username: String, password: String)
}

final class LoginContainerView: UIView {
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleCancelPress(sender:)), for: .touchUpInside)
        return button
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleLoginPress(sender:)), for: .touchUpInside)
        return button
    }()

    weak var delegate: LoginContainerViewDelegate?

    var viewModel: LoginViewModel? {
        didSet {
            cancelButton.setTitle(viewModel?.cancelButtonTitle, for: .normal)
            loginButton.setTitle(viewModel?.loginButtonTitle, for: .normal)
            usernameTextField.placeholder = viewModel?.usernamePlaceholder
            passwordTextField.placeholder = viewModel?.passwordPlaceholder
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpTextFields()
        setUpButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpTextFields() {
        addSubview(usernameTextField)
        addSubview(passwordTextField)

        usernameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LoginConstants.textFieldMargin)
            make.left.equalToSuperview().offset(LoginConstants.textFieldMargin)
            make.right.equalToSuperview().offset(-LoginConstants.textFieldMargin)
            make.height.equalTo(LoginConstants.textFieldHeight)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(LoginConstants.textFieldMargin)
            make.left.equalTo(usernameTextField)
            make.right.equalTo(usernameTextField)
            make.height.equalTo(usernameTextField)
        }

        usernameTextField.delegate = self
        usernameTextField.borderStyle = .none
        usernameTextField.backgroundColor = LoginConstants.textFieldBackgroundColor
        usernameTextField.returnKeyType = .next
        usernameTextField.autocapitalizationType = .none
        usernameTextField.returnKeyType = .next

        passwordTextField.delegate = self
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = LoginConstants.textFieldBackgroundColor
        passwordTextField.autocapitalizationType = .none
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
    }

    private func setUpButtons() {
        addSubview(cancelButton)
        addSubview(loginButton)

        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.top.equalTo(passwordTextField.snp.bottom).offset(LoginConstants.textFieldMargin)
        }

        loginButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.top.equalTo(passwordTextField.snp.bottom).offset(LoginConstants.textFieldMargin)
        }
    }

    func focusInputField() {
        usernameTextField.becomeFirstResponder()
    }

    @objc
    private func handleCancelPress(sender: Any) {
        delegate?.didTapCancel()
    }

    @objc
    private func handleLoginPress(sender: Any) {
        delegate?.didTapLogin(username: usernameTextField.text ?? "",
                              password: passwordTextField.text ?? "")
    }
}

// MARK: - UITextFieldDelegate
extension LoginContainerView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            handleLoginPress(sender: textField)
        }
        return true
    }
}
