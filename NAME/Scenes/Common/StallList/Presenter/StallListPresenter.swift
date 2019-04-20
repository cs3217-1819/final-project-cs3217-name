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
    func display(establishment: StallListEstablishmentViewModel)
    func display(stallList: StallListViewModel)
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
    func present(establishmentInfo: Establishment) {
        let viewModel = StallListEstablishmentViewModel(name: establishmentInfo.name)
        output.display(establishment: viewModel)
    }

    func present(stalls: [Stall]) {
        let stallViewModels = stalls.map { StallListViewModel.StallViewModel(name: $0.name, location: $0.location) }
        let viewModel = StallListViewModel(stalls: stallViewModels)
        output.display(stallList: viewModel)
    }

    func presentStallDeleteError() {
        output.displayStallDeleteError()
    }
}
