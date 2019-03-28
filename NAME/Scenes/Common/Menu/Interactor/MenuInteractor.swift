//
//  MenuInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuInteractorInput: MenuViewControllerOutput {

}

protocol MenuInteractorOutput {

    func presentSomething()
}

final class MenuInteractor {

    let output: MenuInteractorOutput
    let worker: MenuWorker

    // MARK: - Initializers

    init(output: MenuInteractorOutput, worker: MenuWorker = MenuWorker()) {

        self.output = output
        self.worker = worker
    }
}

// MARK: - MenuInteractorInput

extension MenuInteractor: MenuViewControllerOutput {

    // MARK: - Business logic

    func doSomething() {

        // TODO: Create some Worker to do the work

        worker.doSomeWork()

        // TODO: Pass the result to the Presenter

        output.presentSomething()
    }
}
