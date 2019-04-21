//
//  LoginPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol LoginPresenterInput: LoginInteractorOutput {

}

protocol LoginPresenterOutput: class {
    func displayLoginContainer(viewModel: LoginViewModel)
    func displayLoginError()
    func displayStall(withId id: String)
    func displayEstablishment(withId id: String)
}

final class LoginPresenter {

    private(set) unowned var output: LoginPresenterOutput

    // MARK: - Initializers

    init(output: LoginPresenterOutput) {
        self.output = output
    }
}

// MARK: - LoginPresenterInput

extension LoginPresenter: LoginPresenterInput {
    func presentDefaultScreen() {
        let viewModel = LoginViewModel()
        output.displayLoginContainer(viewModel: viewModel)
    }

    func presentLoginFailure() {
        output.displayLoginError()
    }

    func presentStall(withId id: String) {
        output.displayStall(withId: id)
    }

    func presentEstablishment(withId id: String) {
        output.displayEstablishment(withId: id)
    }
}
