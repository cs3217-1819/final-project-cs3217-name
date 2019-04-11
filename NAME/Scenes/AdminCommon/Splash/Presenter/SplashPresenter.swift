//
//  SplashPresenter.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol SplashPresenterInput: SplashInteractorOutput {
}

protocol SplashPresenterOutput: class {
    func reloadDisplay(viewModel: SplashViewModel)
}

final class SplashPresenter {
    private(set) unowned var output: SplashPresenterOutput

    init(output: SplashPresenterOutput) {
        self.output = output
    }
}

// MARK: - SplashPresenterInput

extension SplashPresenter: SplashPresenterInput {
    func presentInit() {
        let viewModel = SplashViewModel()
        output.reloadDisplay(viewModel: viewModel)
    }
}
