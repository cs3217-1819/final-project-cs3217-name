//
//  StallRootInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallRootInteractorInput: StallRootViewControllerOutput {
}

protocol StallRootInteractorOutput {
    func present(stallId: String)
    func presentLogout()
}

final class StallRootInteractor {
    fileprivate struct Dependencies {
        let authManager: AuthManager
    }
    private let deps: Dependencies

    private let output: StallRootInteractorOutput
    private let worker: StallRootWorker

    private let stallId: String

    // MARK: - Initializers
    init(output: StallRootInteractorOutput,
         stallId: String,
         injector: DependencyInjector = appDefaultInjector,
         worker: StallRootWorker = StallRootWorker()) {
        self.deps = injector.dependencies()
        self.stallId = stallId
        self.output = output
        self.worker = worker
    }
}

// MARK: - StallRootInteractorInput
extension StallRootInteractor: StallRootInteractorInput {
    func loadStall() {
        output.present(stallId: stallId)
    }

    func logout() {
        deps.authManager.logout()
        output.presentLogout()
    }
}

// MARK: - Dependency Injection

extension DependencyInjector {
    fileprivate func dependencies() -> StallRootInteractor.Dependencies {
        return StallRootInteractor.Dependencies(authManager: authManager)
    }
}
