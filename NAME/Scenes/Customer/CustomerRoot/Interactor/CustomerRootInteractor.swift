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
}

final class CustomerRootInteractor {
    let output: CustomerRootInteractorOutput
    let worker: CustomerRootWorker

    init(output: CustomerRootInteractorOutput, worker: CustomerRootWorker = CustomerRootWorker()) {
        self.output = output
        self.worker = worker
    }
}

// MARK: - CustomerRootInteractorInput

extension CustomerRootInteractor: CustomerRootViewControllerOutput {
}
