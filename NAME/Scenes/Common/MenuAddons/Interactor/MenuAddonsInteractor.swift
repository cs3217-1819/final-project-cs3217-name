//
//  MenuAddonsInteractor.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuAddonsInteractorInput: MenuAddonsViewControllerOutput {

}

protocol MenuAddonsInteractorOutput {
    func presentSomething()
}

final class MenuAddonsInteractor {
    let output: MenuAddonsInteractorOutput
    let worker: MenuAddonsWorker

    // MARK: - Initializers
    init(output: MenuAddonsInteractorOutput, worker: MenuAddonsWorker = MenuAddonsWorker()) {
        self.output = output
        self.worker = worker
    }
}

// MARK: - MenuAddonsInteractorInput
extension MenuAddonsInteractor: MenuAddonsViewControllerOutput {
    func doSomething() {
        // TODO: Create some Worker to do the work
        worker.doSomeWork()
        // TODO: Pass the result to the Presenter
        output.presentSomething()
    }
}
