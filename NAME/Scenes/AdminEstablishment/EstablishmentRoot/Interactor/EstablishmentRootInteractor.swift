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
}
