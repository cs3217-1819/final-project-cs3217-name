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

    // MARK: - Presentation logic

    func presentSomething() {

        // TODO: Format the response from the Interactor and pass the result back to the View Controller

        let viewModel = LoginViewModel()
        output.displayLoginContainer(viewModel: viewModel)
    }
}
