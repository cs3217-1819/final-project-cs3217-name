//
//  EstablishmentRootInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol EstablishmentRootInteractorInput: EstablishmentRootViewControllerOutput {
}

protocol EstablishmentRootInteractorOutput {
    func present(estId: String)
    func presentLogout()
}

final class EstablishmentRootInteractor {
    fileprivate struct Dependencies {
        let authManager: AuthManager
    }
    private let deps: Dependencies

    private let output: EstablishmentRootInteractorOutput
    private let worker: EstablishmentRootWorker

    private let estId: String

    // MARK: - Initializers
    init(output: EstablishmentRootInteractorOutput,
         estId: String,
         injector: DependencyInjector = appDefaultInjector,
         worker: EstablishmentRootWorker = EstablishmentRootWorker()) {
        self.deps = injector.dependencies()
        self.estId = estId
        self.output = output
        self.worker = worker
    }
}

// MARK: - EstablishmentRootInteractorInput
extension EstablishmentRootInteractor: EstablishmentRootInteractorInput {
    func loadEstablishment() {
        output.present(estId: estId)
    }

    func logout() {
        deps.authManager.logout()
        output.presentLogout()
    }
}

// MARK: - Dependency Injection

extension DependencyInjector {
    fileprivate func dependencies() -> EstablishmentRootInteractor.Dependencies {
        return EstablishmentRootInteractor.Dependencies(authManager: authManager)
    }
}
