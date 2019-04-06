//
//  MenuInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

// MARK: Interscene interactor IO

protocol MenuFromParentInput: class {
    var stall: Stall? { get set }
}

protocol MenuToParentOutput: class {
    var menuInteractor: MenuFromParentInput? { get set }
}

// MARK: Intrascene interactor IO

protocol MenuInteractorInput: MenuViewControllerOutput {
}

protocol MenuInteractorOutput {
    func presentSomething()
}

final class MenuInteractor: MenuFromParentInput {
    private let output: MenuInteractorOutput
    private let worker: MenuWorker
    private weak var toParentMediator: MenuToParentOutput?

    var stall: Stall? {
        didSet {
            self.doSomething()
        }
    }

    // MARK: - Initializers

    init(output: MenuInteractorOutput,
         toParentMediator: MenuToParentOutput?,
         worker: MenuWorker = MenuWorker()) {
        self.output = output
        self.worker = worker
        self.toParentMediator = toParentMediator
    }
}

// MARK: - MenuInteractorInput

extension MenuInteractor: MenuViewControllerOutput {

    // MARK: - Business logic

    func doSomething() {
        print("Set stall on menu", stall)

        // TODO: Create some Worker to do the work

        worker.doSomeWork()

        // TODO: Pass the result to the Presenter

        output.presentSomething()
    }
}
