//
//  StallListPresenter.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallListPresenterInput: StallListInteractorOutput {

}

protocol StallListPresenterOutput: class {

    func displaySomething(viewModel: StallListViewModel)
}

final class StallListPresenter {

    private(set) unowned var output: StallListPresenterOutput

    // MARK: - Initializers

    init(output: StallListPresenterOutput) {

        self.output = output
    }
}

// MARK: - StallListPresenterInput

extension StallListPresenter: StallListPresenterInput {

    // MARK: - Presentation logic

    func presentSomething() {

        // TODO: Format the response from the Interactor and pass the result back to the View Controller

        let viewModel = StallListViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
