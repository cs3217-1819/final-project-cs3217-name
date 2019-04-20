//
//  CustomerRootInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

// MARK: Interscene interactor IO

protocol CustomerRootFromChildrenInput: class {
    func requestSessionEnd()
}

protocol CustomerRootToChildrenOutput: class {
    var selfInteractor: CustomerRootFromChildrenInput? { get set }
}

// MARK: Intrascene interactor IO

protocol CustomerRootInteractorInput: CustomerRootViewControllerOutput {
}

protocol CustomerRootInteractorOutput {
    func endSession()
}

final class CustomerRootInteractor {
    let output: CustomerRootInteractorOutput
    let worker: CustomerRootWorker
    private let toChildrenMediator: CustomerRootIntersceneMediator

    init(output: CustomerRootInteractorOutput,
         toChildrenMediator: CustomerRootIntersceneMediator,
         worker: CustomerRootWorker = CustomerRootWorker()) {
        self.output = output
        self.toChildrenMediator = toChildrenMediator
        self.worker = worker
    }
}

// MARK: - CustomerRootInteractorInput
extension CustomerRootInteractor: CustomerRootViewControllerOutput {
}

// MARK: - CustomerRootFromChildrenInput
extension CustomerRootInteractor: CustomerRootFromChildrenInput {
    func requestSessionEnd() {
        output.endSession()
    }
}
