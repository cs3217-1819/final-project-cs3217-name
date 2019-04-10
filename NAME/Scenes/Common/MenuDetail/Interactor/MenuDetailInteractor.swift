//
//  MenuDetailInteractor.swift
//  NAME
//
//  Created by Julius on 8/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuDetailInteractorInput: MenuDetailViewControllerOutput {

}

protocol MenuDetailInteractorOutput {
    func presentSomething()
}

final class MenuDetailInteractor {
    let output: MenuDetailInteractorOutput
    let worker: MenuDetailWorker

    // MARK: - Initializers
    init(output: MenuDetailInteractorOutput, worker: MenuDetailWorker = MenuDetailWorker()) {
        self.output = output
        self.worker = worker
    }
}

// MARK: - MenuDetailInteractorInput
extension MenuDetailInteractor: MenuDetailViewControllerOutput {
    func doSomething() {
        // TODO: Create some Worker to do the work
        worker.doSomeWork()
        // TODO: Pass the result to the Presenter
        output.presentSomething()
    }
}
