//
//  EstablishmentRootPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol EstablishmentRootPresenterInput: EstablishmentRootInteractorOutput {
}

protocol EstablishmentRootPresenterOutput: class {
    func displaySomething(viewModel: EstablishmentRootViewModel)
}

final class EstablishmentRootPresenter {
    private(set) unowned var output: EstablishmentRootPresenterOutput

    // MARK: - Initializers
    init(output: EstablishmentRootPresenterOutput) {
        self.output = output
    }
}

// MARK: - EstablishmentRootPresenterInput
extension EstablishmentRootPresenter: EstablishmentRootPresenterInput {
    func presentSomething() {
        // TODO: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = EstablishmentRootViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
