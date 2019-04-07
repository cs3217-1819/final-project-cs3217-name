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
    func present(stall: Stall?)
}

final class MenuInteractor: MenuFromParentInput {
    private let output: MenuInteractorOutput
    private let worker: MenuWorker
    private weak var toParentMediator: MenuToParentOutput?

    var stall: Stall? {
        didSet {
            output.present(stall: stall)
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
}
