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

    func displaySomething(viewModel: SplashViewModel)
}

final class SplashPresenter {

    private(set) weak var output: SplashPresenterOutput!


    // MARK: - Initializers

    init(output: SplashPresenterOutput) {

        self.output = output
    }
}


// MARK: - SplashPresenterInput

extension SplashPresenter: SplashPresenterInput {


    // MARK: - Presentation logic

    func presentSomething() {

        // TODO: Format the response from the Interactor and pass the result back to the View Controller

        let viewModel = SplashViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
