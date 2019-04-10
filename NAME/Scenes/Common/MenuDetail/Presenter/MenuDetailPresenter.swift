//
//  MenuDetailPresenter.swift
//  NAME
//
//  Created by Julius on 8/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuDetailPresenterInput: MenuDetailInteractorOutput {

}

protocol MenuDetailPresenterOutput: class {
    func displaySomething(viewModel: MenuDetailViewModel)
}

final class MenuDetailPresenter {
    private(set) unowned var output: MenuDetailPresenterOutput

    // MARK: - Initializers
    init(output: MenuDetailPresenterOutput) {
        self.output = output
    }
}

// MARK: - MenuDetailPresenterInput
extension MenuDetailPresenter: MenuDetailPresenterInput {
    func presentSomething() {
        // TODO: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = MenuDetailViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
