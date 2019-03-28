//
//  MenuPresenter.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuPresenterInput: MenuInteractorOutput {

}

protocol MenuPresenterOutput: class {

    func displaySomething(viewModel: MenuViewModel)
}

final class MenuPresenter {

    private(set) unowned var output: MenuPresenterOutput

    // MARK: - Initializers

    init(output: MenuPresenterOutput) {

        self.output = output
    }
}

// MARK: - MenuPresenterInput

extension MenuPresenter: MenuPresenterInput {

    // MARK: - Presentation logic

    func presentSomething() {

        // TODO: Format the response from the Interactor and pass the result back to the View Controller

        let viewModel = MenuViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
