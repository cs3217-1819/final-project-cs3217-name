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
}

final class BrowseInteractor {
    let output: BrowseInteractorOutput
    let worker: BrowseWorker
    private weak var toParentMediator: BrowseToParentOutput?
    private let toChildrenMediator: BrowseIntersceneMediator

    init(output: BrowseInteractorOutput,
         toParentMediator: BrowseToParentOutput?,
         toChildrenMediator: BrowseIntersceneMediator,
         worker: BrowseWorker = BrowseWorker()) {

        self.output = output
        self.toParentMediator = toParentMediator
        self.toChildrenMediator = toChildrenMediator
        self.worker = worker
    }
}

// MARK: - BrowseInteractorInput
extension BrowseInteractor: BrowseViewControllerOutput {
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
