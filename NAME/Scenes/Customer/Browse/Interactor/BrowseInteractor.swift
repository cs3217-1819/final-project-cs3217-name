//
//  BrowseInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

protocol BrowseInteractorInput: BrowseViewControllerOutput {
}

protocol BrowseInteractorOutput {
}

final class BrowseInteractor {
    let output: BrowseInteractorOutput
    let worker: BrowseWorker
    private let toChildrenMediator: BrowseIntersceneMediator

    init(output: BrowseInteractorOutput,
         toChildrenMediator: BrowseIntersceneMediator,
         worker: BrowseWorker = BrowseWorker()) {

        self.output = output
        self.toChildrenMediator = toChildrenMediator
        self.worker = worker
    }
}

// MARK: - BrowseInteractorInput

extension BrowseInteractor: BrowseViewControllerOutput {
}
