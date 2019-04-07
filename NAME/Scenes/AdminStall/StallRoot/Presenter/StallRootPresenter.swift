//
//  StallRootPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallRootPresenterInput: StallRootInteractorOutput {

}

protocol StallRootPresenterOutput: class {
    func displaySomething(viewModel: StallRootViewModel)
}

final class StallRootPresenter {
    private(set) unowned var output: StallRootPresenterOutput

    // MARK: - Initializers
    init(output: StallRootPresenterOutput) {
        self.output = output
    }
}

// MARK: - StallRootPresenterInput
extension StallRootPresenter: StallRootPresenterInput {
    func presentSomething() {
        // TODO: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = StallRootViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
