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
    func displayStallDeleteError()
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

    func presentStalls(stalls: [Stall]) {
        let stallViewModels = stalls.map { StallListViewModel.StallViewModel(name: $0.name, location: $0.location) }
        let viewModel = StallListViewModel(stalls: stallViewModels)
        output.displaySomething(viewModel: viewModel)
    }

    func presentStallDeleteError() {
        output.displayStallDeleteError()
    }
}
