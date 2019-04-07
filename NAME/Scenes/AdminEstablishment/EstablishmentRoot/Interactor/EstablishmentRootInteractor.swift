//
//  EstablishmentRootInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol EstablishmentRootInteractorInput: EstablishmentRootViewControllerOutput {
}

protocol EstablishmentRootInteractorOutput {
    func presentSomething()
}

final class EstablishmentRootInteractor {
    let output: EstablishmentRootInteractorOutput
    let worker: EstablishmentRootWorker

    // MARK: - Initializers
    init(output: EstablishmentRootInteractorOutput, worker: EstablishmentRootWorker = EstablishmentRootWorker()) {
        self.output = output
        self.worker = worker
    }
}

// MARK: - EstablishmentRootInteractorInput
extension EstablishmentRootInteractor: EstablishmentRootViewControllerOutput {
    func doSomething() {
        // TODO: Create some Worker to do the work
        worker.doSomeWork()
        // TODO: Pass the result to the Presenter
        output.presentSomething()
    }
}
