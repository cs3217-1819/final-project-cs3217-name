//
//  BrowseInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol BrowseInteractorInput: BrowseViewControllerOutput {

}

protocol BrowseInteractorOutput {

    func presentSomething()
}

final class BrowseInteractor {

    let output: BrowseInteractorOutput
    let worker: BrowseWorker

    // MARK: - Initializers

    init(output: BrowseInteractorOutput, worker: BrowseWorker = BrowseWorker()) {

        self.output = output
        self.worker = worker
    }
}

// MARK: - BrowseInteractorInput

extension BrowseInteractor: BrowseViewControllerOutput {

    // MARK: - Business logic

    func doSomething() {

        // TODO: Create some Worker to do the work

        worker.doSomeWork()

        // TODO: Pass the result to the Presenter

        output.presentSomething()
    }
}
