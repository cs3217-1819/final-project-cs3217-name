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
    func presentLoginFailure()
    func presentStall(withId id: String)
    func presentEstablishment(withId id: String)
}

final class LoginInteractor {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
        let authManager: AuthManager
    }
    private let deps: Dependencies

    let output: LoginInteractorOutput
    let worker: LoginWorker

    // MARK: - Initializers

    init(output: LoginInteractorOutput, injector: DependencyInjector, worker: LoginWorker = LoginWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.worker = worker
    }
}

// MARK: - LoginInteractorInput

extension LoginInteractor: LoginViewControllerOutput {
    func handleLogin(username: String, password: String) {
        guard deps.authManager.login(withUsername: username, password: password) != nil else {
            output.presentLoginFailure()
            return
        }

        guard let (id, accountType) = deps.authManager.getCurrentStallOrEstablishment() else {
            assertionFailure("Access control was not set.")
            return
        }
        switch accountType {
        case .stall:
            output.presentStall(withId: id)
        case .establishment:
            output.presentEstablishment(withId: id)
        }
    }

    func initializeScreen() {
        output.presentDefaultScreen()
    }
}

// MARK: - Dependency injection
extension DependencyInjector {
    fileprivate func dependencies() -> LoginInteractor.Dependencies {
        return LoginInteractor.Dependencies(storageManager: storageManager,
                                            authManager: authManager)
    }
}
