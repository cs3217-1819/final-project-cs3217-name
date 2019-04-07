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

    func presentSomething()
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

    // MARK: - Business logic

    func doSomething() {

        // TODO: Create some Worker to do the work

        worker.doSomeWork()

        // TODO: Pass the result to the Presenter

        output.presentSomething()
    }
}
