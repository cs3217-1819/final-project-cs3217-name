//
//  SplashInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol SplashInteractorInput: SplashViewControllerOutput {

}

protocol SplashInteractorOutput {

    func presentSomething()
}

final class SplashInteractor {

    let output: SplashInteractorOutput
    let worker: SplashWorker


    // MARK: - Initializers

    init(output: SplashInteractorOutput, worker: SplashWorker = SplashWorker()) {

        self.output = output
        self.worker = worker
    }
}


// MARK: - SplashInteractorInput

extension SplashInteractor: SplashViewControllerOutput {


    // MARK: - Business logic

    func doSomething() {

        // TODO: Create some Worker to do the work

        worker.doSomeWork()

        // TODO: Pass the result to the Presenter

        output.presentSomething()
    }
}
