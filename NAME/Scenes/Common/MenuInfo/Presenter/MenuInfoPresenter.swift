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
    func display(comment: String)
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
    func presentComment(_ comment: String) {
        output.display(comment: comment)
    }

    func presentMenuDisplayable(_ menuDisplayable: MenuDisplayable) {
        let viewModel = MenuInfoViewModel(name: menuDisplayable.name,
                                          details: menuDisplayable.details,
                                          price: menuDisplayable.price.formattedAsPrice())
        output.display(viewModel: viewModel)
    }
}
