//
//  BrowseInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

// MARK: Interscene interactor IO

protocol BrowseFromParentInput: class {
}

protocol BrowseToParentOutput: class {
    var browseInteractor: BrowseFromParentInput? { get set }
    func requestSessionEnd()
}

protocol BrowseFromChildrenInput: class {
    func requestSessionEnd()
}

protocol BrowseToChildrenOutput: class {
    var selfInteractor: BrowseFromChildrenInput? { get set }
}

// MARK: Intrascene interactor IO

protocol BrowseInteractorInput: BrowseViewControllerOutput {
}

protocol BrowseInteractorOutput {
    func presentChildren(withEstId id: String)
}

final class BrowseInteractor {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    let output: BrowseInteractorOutput
    let worker: BrowseWorker
    private weak var toParentMediator: BrowseToParentOutput?
    private let toChildrenMediator: BrowseIntersceneMediator

    init(output: BrowseInteractorOutput,
         injector: DependencyInjector,
         toParentMediator: BrowseToParentOutput?,
         toChildrenMediator: BrowseIntersceneMediator,
         worker: BrowseWorker = BrowseWorker()) {

        deps = injector.dependencies()
        self.output = output
        self.toParentMediator = toParentMediator
        self.toChildrenMediator = toChildrenMediator
        self.worker = worker
    }
}

// MARK: - BrowseInteractorInput
extension BrowseInteractor: BrowseInteractorInput {
    func reloadChildren() {
        // Hackish, but when in customer mode, show the first establishment
        guard let currentEst = deps.storageManager.allEstablishments().first else {
            return
        }
        output.presentChildren(withEstId: currentEst.id)
    }
}

// MARK: - BrowseFromParentInput
extension BrowseInteractor: BrowseFromParentInput {
}

// MARK: - BrowseFromChildrenInput
extension BrowseInteractor: BrowseFromChildrenInput {
    func requestSessionEnd() {
        toParentMediator?.requestSessionEnd()
    }
}

// MARK: - Dependency injection
extension DependencyInjector {
    fileprivate func dependencies() -> BrowseInteractor.Dependencies {
        return BrowseInteractor.Dependencies(storageManager: storageManager)
    }
}
