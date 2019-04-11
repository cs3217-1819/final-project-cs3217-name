//
//  StallRootInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallRootInteractorInput: StallRootViewControllerOutput {

}

protocol StallRootInteractorOutput {
}

final class StallRootInteractor {
    let output: StallRootInteractorOutput
    let worker: StallRootWorker

    // MARK: - Initializers
    init(output: StallRootInteractorOutput, worker: StallRootWorker = StallRootWorker()) {
        self.output = output
        self.worker = worker
    }
}

// MARK: - StallRootInteractorInput
extension StallRootInteractor: StallRootViewControllerOutput {
}
