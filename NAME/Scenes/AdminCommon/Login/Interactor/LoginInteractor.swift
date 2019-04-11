//
//  LoginInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol LoginInteractorInput: LoginViewControllerOutput {

}

protocol LoginInteractorOutput {

    func presentDefaultScreen()
}

final class LoginInteractor {

    let output: LoginInteractorOutput
    let worker: LoginWorker

    // MARK: - Initializers

    init(output: LoginInteractorOutput, worker: LoginWorker = LoginWorker()) {

        self.output = output
        self.worker = worker
    }
}

// MARK: - LoginInteractorInput

extension LoginInteractor: LoginViewControllerOutput {
    func initializeScreen() {
        output.presentDefaultScreen()
    }
}
