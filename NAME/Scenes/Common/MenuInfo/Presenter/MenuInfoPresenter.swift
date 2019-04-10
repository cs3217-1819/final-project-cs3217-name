//
//  MenuInfoPresenter.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuInfoPresenterInput: MenuInfoInteractorOutput {

}

protocol MenuInfoPresenterOutput: class {
    func display(viewModel: MenuInfoViewModel)
}

final class MenuInfoPresenter {
    private(set) unowned var output: MenuInfoPresenterOutput

    // MARK: - Initializers
    init(output: MenuInfoPresenterOutput) {
        self.output = output
    }
}

// MARK: - MenuInfoPresenterInput
extension MenuInfoPresenter: MenuInfoPresenterInput {
    func presentMenuDisplayable(_ menuDisplayable: MenuDisplayable) {
        // TODO: Format the response from the Interactor and pass the result back to the View Controller
        guard let price = menuDisplayable.price.formattedAsPrice() else {
            assertionFailure("Unable to format price")
            return
        }
        let viewModel = MenuInfoViewModel(name: menuDisplayable.name,
                                          details: menuDisplayable.details,
                                          price: price)
        output.display(viewModel: viewModel)
    }
}
