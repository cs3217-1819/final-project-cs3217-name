//
//  StallListInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

// MARK: Interscene interactor IO

protocol StallListFromParentInput: class {
}

protocol StallListToParentOutput: class {
    var stallListInteractor: StallListFromParentInput? { get set }
    var selectedStall: Stall? { get set }
}

// MARK: Intrascene interactor IO

protocol StallListInteractorInput: StallListViewControllerOutput {
}

protocol StallListInteractorOutput {
    func presentStalls(stalls: [Stall])
    func presentStallDeleteError()
}

final class StallListInteractor: StallListFromParentInput {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    private let output: StallListInteractorOutput
    private let worker: StallListWorker
    private weak var toParentMediator: StallListToParentOutput?

    private var loadedStalls: [Stall] = []

    // MARK: - Initializers

    init(output: StallListInteractorOutput,
         injector: DependencyInjector,
         toParentMediator: StallListToParentOutput?,
         worker: StallListWorker = StallListWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.worker = worker
        self.toParentMediator = toParentMediator
    }
}

// MARK: - StallListInteractorInput

extension StallListInteractor: StallListViewControllerOutput {
    func reloadStalls() {
        // TODO: Filter stalls by actual current establishment
        guard let currentEstablishment = deps.storageManager.allEstablishments().first else {
            print("Could not get stalls")
            return
        }
        loadedStalls = Array(currentEstablishment.stalls)
        output.presentStalls(stalls: loadedStalls)
    }

    func handleStallSelect(at index: Int) {
        toParentMediator?.selectedStall = loadedStalls[index]
    }

    func handleStallDelete(at index: Int) {
        do {
            try deps.storageManager.writeTransaction { $0.delete(loadedStalls[index]) }
            reloadStalls()
        } catch {
            output.presentStallDeleteError()
        }
    }
}

// MARK: - Dependency injection

extension DependencyInjector {
    fileprivate func dependencies() -> StallListInteractor.Dependencies {
        return StallListInteractor.Dependencies(storageManager: storageManager)
    }
}
