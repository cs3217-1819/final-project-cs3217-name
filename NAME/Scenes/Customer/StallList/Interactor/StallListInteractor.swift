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

    func presentSomething()
}

final class StallListInteractor {

    let output: StallListInteractorOutput
    let worker: StallListWorker

    // MARK: - Initializers

    init(output: StallListInteractorOutput, worker: StallListWorker = StallListWorker()) {

        self.output = output
        self.worker = worker
    }
}

// MARK: - StallListInteractorInput

extension StallListInteractor: StallListViewControllerOutput {

    // MARK: - Business logic

    func doSomething() {

        // TODO: Create some Worker to do the work

        worker.doSomeWork()

        // TODO: Pass the result to the Presenter

        output.presentSomething()
    }
}
