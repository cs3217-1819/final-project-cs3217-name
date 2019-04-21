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
    func displayStallSettings(withId id: String)
    func displayStallDeleteError(title: String, message: String, buttonText: String?)
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

    func presentStallSettings(forStallId id: String) {
        output.displayStallSettings(withId: id)
    }

    func presentStallDeleteError() {
        output.displayStallDeleteError(title: ErrorMessage.stallDeleteErrorTitle,
                                       message: ErrorMessage.stallDeleteErrorMessage,
                                       buttonText: nil)
    }
}
