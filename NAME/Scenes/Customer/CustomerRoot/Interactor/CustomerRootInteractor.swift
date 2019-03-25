//
//  CustomerRootInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomerRootInteractorInput: CustomerRootViewControllerOutput {

}

protocol CustomerRootInteractorOutput {

    func presentSomething()
}

final class CustomerRootInteractor {

    let output: CustomerRootInteractorOutput
    let worker: CustomerRootWorker


    // MARK: - Initializers

    init(output: CustomerRootInteractorOutput, worker: CustomerRootWorker = CustomerRootWorker()) {

        self.output = output
        self.worker = worker
    }
}


// MARK: - CustomerRootInteractorInput

extension CustomerRootInteractor: CustomerRootViewControllerOutput {


    // MARK: - Business logic

    func doSomething() {

        // TODO: Create some Worker to do the work

        worker.doSomeWork()

        // TODO: Pass the result to the Presenter

        output.presentSomething()
    }
}
