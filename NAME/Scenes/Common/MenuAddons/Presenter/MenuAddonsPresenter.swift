//
//  MenuAddonsPresenter.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuAddonsPresenterInput: MenuAddonsInteractorOutput {

}

protocol MenuAddonsPresenterOutput: class {
    func displaySomething(viewModel: MenuAddonsViewModel)
}

final class MenuAddonsPresenter {
    private(set) unowned var output: MenuAddonsPresenterOutput

    // MARK: - Initializers
    init(output: MenuAddonsPresenterOutput) {
        self.output = output
    }
}

// MARK: - MenuAddonsPresenterInput
extension MenuAddonsPresenter: MenuAddonsPresenterInput {
    func presentSomething() {
        // TODO: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = MenuAddonsViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
