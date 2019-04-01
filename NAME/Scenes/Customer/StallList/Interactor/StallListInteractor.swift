//
//  StallListInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallListInteractorInput: StallListViewControllerOutput {
}

protocol StallListInteractorOutput {
    func presentStalls(stalls: [Stall])
}

final class StallListInteractor {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    let output: StallListInteractorOutput
    let worker: StallListWorker

    private var loadedStalls: [Stall] = []

    // MARK: - Initializers

    init(output: StallListInteractorOutput,
         injector: DependencyInjector,
         worker: StallListWorker = StallListWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.worker = worker
    }
}

// MARK: - StallListInteractorInput

extension StallListInteractor: StallListViewControllerOutput {

    // MARK: - Business logic

    func reloadStalls() {
        // TODO: Filter stalls by actual current establishment
        guard let currentEstablishment = deps.storageManager.allEstablishments().first else {
            print("Could not get stalls")
            return
        }
        let stalls = Array(currentEstablishment.stalls)
        output.presentStalls(stalls: stalls)
    }
}

// MARK: - Dependency injection

extension DependencyInjector {
    fileprivate func dependencies() -> StallListInteractor.Dependencies {
        return StallListInteractor.Dependencies(storageManager: storageManager)
    }
}
