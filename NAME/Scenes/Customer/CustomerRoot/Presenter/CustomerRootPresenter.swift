//
//  CustomerRootPresenter.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomerRootPresenterInput: CustomerRootInteractorOutput {

}

protocol CustomerRootPresenterOutput: class {

    func displaySomething(viewModel: CustomerRootViewModel)
}

final class CustomerRootPresenter {

    private(set) unowned var output: CustomerRootPresenterOutput

    // MARK: - Initializers

    init(output: CustomerRootPresenterOutput) {

        self.output = output
    }
}

// MARK: - CustomerRootPresenterInput

extension CustomerRootPresenter: CustomerRootPresenterInput {

    // MARK: - Presentation logic

    func presentSomething() {

        // TODO: Format the response from the Interactor and pass the result back to the View Controller

        let viewModel = CustomerRootViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
