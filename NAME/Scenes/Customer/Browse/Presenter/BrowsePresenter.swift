//
//  BrowsePresenter.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol BrowsePresenterInput: BrowseInteractorOutput {

}

protocol BrowsePresenterOutput: class {

    func displaySomething(viewModel: BrowseViewModel)
}

final class BrowsePresenter {

    private(set) unowned var output: BrowsePresenterOutput

    // MARK: - Initializers

    init(output: BrowsePresenterOutput) {

        self.output = output
    }
}

// MARK: - BrowsePresenterInput

extension BrowsePresenter: BrowsePresenterInput {

    // MARK: - Presentation logic

    func presentSomething() {

        // TODO: Format the response from the Interactor and pass the result back to the View Controller

        let viewModel = BrowseViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
