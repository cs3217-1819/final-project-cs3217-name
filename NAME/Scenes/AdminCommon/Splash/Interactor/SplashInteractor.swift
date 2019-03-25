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
    func presentInit()
}

final class SplashInteractor {
    let output: SplashInteractorOutput

    // MARK: - Initializers

    init(output: SplashInteractorOutput) {
        self.output = output
    }
}


// MARK: - SplashInteractorInput

extension SplashInteractor: SplashViewControllerOutput {
    // MARK: - Business logic
    func initializeScreen() {
        output.presentInit()
    }
}
